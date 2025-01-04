$allRepos = @()
$perPage = 999
$username = "YOUR_GITHUB_USERNAME"

do {
    $repos = gh repo list $username --json archivedAt,assignableUsers,codeOfConduct,contactLinks,createdAt,defaultBranchRef,deleteBranchOnMerge,description,diskUsage,forkCount,fundingLinks,hasDiscussionsEnabled,hasIssuesEnabled,hasProjectsEnabled,hasWikiEnabled,homepageUrl,id,isArchived,isBlankIssuesEnabled,isEmpty,isFork,isInOrganization,isMirror,isPrivate,isSecurityPolicyEnabled,isTemplate,isUserConfigurationRepository,issueTemplates,issues,labels,languages,latestRelease,licenseInfo,mentionableUsers,mergeCommitAllowed,milestones,mirrorUrl,name,nameWithOwner,openGraphImageUrl,owner,parent,primaryLanguage,projects,projectsV2,pullRequestTemplates,pullRequests,pushedAt,rebaseMergeAllowed,repositoryTopics,securityPolicyUrl,squashMergeAllowed,sshUrl,stargazerCount,templateRepository,updatedAt,url,usesCustomOpenGraphImage,viewerCanAdminister,viewerDefaultCommitEmail,viewerDefaultMergeMethod,viewerHasStarred,viewerPermission,viewerPossibleCommitEmails,viewerSubscription,visibility,watchers --visibility public --source --limit $perPage | ConvertFrom-Json
    $allRepos += $repos
} while ($repos.Count -eq $perPage)

# Sort the results by the 'url' field
$sortedRepos = $allRepos | Sort-Object url

# Save the sorted results to a file
$sortedRepos | ConvertTo-Json | Out-File -FilePath "all_repos_sorted.json"


$allRepos = @()
$perPage = 999
$username = "ewdlop"

do {
    $repos = gh repo list $username --json name,url --visibility public --source --limit $perPage | ConvertFrom-Json
    $allRepos += $repos
} while ($repos.Count -eq $perPage)

# Sort the results by the 'url' field
$sortedRepos = $allRepos | Sort-Object url

# Save the sorted results to a file
$sortedRepos | ConvertTo-Json | Out-File -FilePath "all_repos_sorted.json"
