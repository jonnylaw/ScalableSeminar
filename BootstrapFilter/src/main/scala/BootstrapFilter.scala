package filter

import breeze.stats.distributions.{Gaussian, Multinomial}
import breeze.linalg.DenseVector
import breeze.numerics._

object BootstrapFilter {
  type State = Double
  type TimeIncrement = Double
  type Time = Double
  type LogLikelihood = Double

  case class Data(time: Time, observation: Double, state: Double)
  case class FilterState(t0: Time, state: Seq[State])

  def stepModel(d: Data, dt: TimeIncrement, v: Double, stepState: (State, TimeIncrement) => State): Data = {
    val x1 = stepState(d.state, dt)
    Data(d.time + dt, Gaussian(x1, v).draw, x1)
  }

  def simModel(dt: TimeIncrement, v: Double, stepState: (State, TimeIncrement) => State): Stream[Data] = {
    val x0 = Gaussian(0.0, 1.0).draw
    val init = Data(0.0, x0, Gaussian(x0, v).draw)
    Stream.iterate(init)(d => stepModel(d, dt, v, stepState))
  }

  /**
    * Step a generalized brownian motion state space
    */
  def stepBrownian(mu: Double, sigma: Double)
    (x: State, dt: TimeIncrement): State = {
      Gaussian(x + mu * dt, sigma * sigma * dt).draw
  }

  def resample(w: Seq[LogLikelihood], x: Seq[State]) = {
    Multinomial(DenseVector(w.toArray)).sample(x.size) map (i => x(i))
  }


  def stepFilter(stepState: (State, TimeIncrement) => State, v: Double)(s: FilterState, d: Data): FilterState = {
    val dt = d.time - s.t0
    val state = s.state map (x => stepState(x, dt))
    val w = state map (x => Gaussian(x, v).logPdf(d.observation))

    val max = w.max
    val w1 = w map { a => exp(a - max) }

    FilterState(d.time, resample(w1, state))
  }

  def main(args: Array[String]) = {
    val (v, mu, sigma) = (1.0, 0.1, 0.5)
    val sims = simModel(0.1, v, stepBrownian(mu, sigma))
    val n = 10

    sims.
      drop(1).
      take(100).
      scanLeft(FilterState(0.0, Gaussian(0.0, 1.0).sample(n)))(stepFilter(stepBrownian(mu, sigma), v)).
      foreach(println)
  }
}
