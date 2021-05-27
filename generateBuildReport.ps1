$headers = @{
  Authorization="Bearer eyJ0eXAiOiAiVENWMiJ9.ZzFicHh3NVBYeVJVZWgtSGROc0ZsWTRPWmw0.OWQ1N2JhNjMtMTNlNy00ODI2LThkY2UtOWMyNDUxNTZlODYz"
}
[xml]$buildInfo = (Invoke-WebRequest -URI http://localhost:3500/app/rest/builds/%teamcity.build.id% -UseBasicParsing -Headers $headers).Content

$branchName = $buildInfo.build.revisions.revision.vcsBranchName
$gitVersion = $buildInfo.build.revisions.revision.version
$buildConfigId = $buildInfo.build.buildType.id
$buildConfigName = $buildInfo.build.buildType.name
$buildNumber = $buildInfo.build.number

$gitRepoUrl = $buildInfo.build.revisions.revision.'vcs-root-instance'.name
$pos = $gitRepoUrl.IndexOf("#");
$gitRepoUrl = $gitRepoUrl.Substring(0,$pos);

[String[]]$tags = @()
foreach ($tag in $buildInfo.build.tags.tag) {
  [String[]]$tags+= $tag.name
}

Write-Output $branchName, $buildConfigId, $buildConfigName, $gitRepoUrl, $tags

$Report = "<html>
<style>
{font-family: Arial; font-size: 13pt;}
TABLE{border: 1px solid black; border-collapse: collapse; font-size:13pt;}
TH{border: 1px solid black; background: #dddddd; padding: 5px; color: #000000;}
TD{border: 1px solid black; padding: 5px; }
</style>
<h2>Build Report</h2>
<table>
<tr>
  <th>Build Number:</th>
  <td>$buildNumber</td>
</tr>
<tr>
  <th>Build Config Name:</th>
  <td>$buildConfigName</td>
</tr>
<tr>
  <th>Build Config Id:</th>
  <td>$buildConfigId</td>
</tr>
<tr>
  <th>Branch Name:</th>
  <td>$branchName</td>
</tr>
<tr>
  <th>Git version:</th>
  <td>$gitVersion</td>
</tr>
<tr>
  <th>Repo url:</th>
  <td>$gitRepoUrl</td>
</tr>
<tr>
  <th>Tags:</th>
  <td>$tags</td>
</tr>
</table>
<tr>
"
$Report | Out-File .\BuildReport.html