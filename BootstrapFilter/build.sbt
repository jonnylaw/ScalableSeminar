name := "BootstrapFilter"

version := "1.0"

scalaVersion := "2.11.8"

resolvers ++= Seq(
  "Sonatype Releases" at "https://oss.sonatype.org/content/repositories/releases/",
  "Sonatype Snapshots" at "http://oss.sonatype.org/content/repositories/snapshots",
  Resolver.sonatypeRepo("public")
)

libraryDependencies  ++= Seq(
   "org.scalanlp" %% "breeze" % "0.12",
  "com.github.fommil.netlib" % "all" % "1.1.2",
  "com.typesafe.akka" %% "akka-stream" % "2.4.12",
  "com.github.jonnylaw" %% "composablemodels" % "0.1"
)
