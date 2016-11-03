package filter

import filter.BootstrapFilter._

import breeze.stats.distributions._

import akka.stream._
import scaladsl._
import akka.util.ByteString
import akka.actor.ActorSystem
import java.nio.file.Paths

object ParallelParticleFilter {
  def main(args: Array[String]) = {
    implicit val system = ActorSystem("ParallelFilter")
    implicit val materializer = ActorMaterializer()

    // Gamma is parameterized with shape and scale
    val variance: Rand[Double] = Gamma(5.0, 0.2)

    val (true_v, mu, sigma) = (1.0, 0.1, 0.5)
    val sims = simModel(0.1, true_v, stepBrownian(mu, sigma))
    val n = 1000

    Source(variance.sample(4).toList).
      mapAsync(2){ v =>
        Source(sims).
          drop(1).
          take(100).
          scan(FilterState(0.0, Gaussian(0.0, 1.0).sample(n)))(stepFilter(stepBrownian(mu, sigma), v)).
          map(s => ByteString(s"$s, \n")).
          runWith(FileIO.toPath(Paths.get(s"ParticleFilter-$v.csv")))
      }.
      runWith(Sink.onComplete(_ => system.terminate))
  }
}
