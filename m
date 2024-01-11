Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2C011704
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 09:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D7D92F4;
	Thu, 11 Jan 2024 01:14:24 -0800 (PST)
Received: from [192.168.1.13] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 164903F64C;
	Thu, 11 Jan 2024 01:13:37 -0800 (PST)
Message-ID: <76a1bb98-a573-4bd2-aee3-b1b98cc5be74@arm.com>
Date: Thu, 11 Jan 2024 10:13:31 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libtracecmd rbtree: Fix deletion of leaf nodes
To: Steven Rostedt <rostedt@goodmis.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240110103941.2e26da60@gandalf.local.home>
Content-Language: en-US
From: Pierre Gondois <pierre.gondois@arm.com>
In-Reply-To: <20240110103941.2e26da60@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for the fix,
Tested-by: Pierre Gondois <pierre.gondois@arm.com>

On 1/10/24 16:39, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> In the rbtree deletion, the deletion had the logic:
> 
> 	if (!node->left || !node->right)
> 		y = node;
> 	else
> 		y = next_node(node);
> 
> 	if (y->left)
> 		x = y->left;
> 	else
> 		x = y->right;
> 
> 	x->parent = y->parent;
> 
> Where if the node had both right and left, the y returned would not have
> children. This is fine, but the x would be NULL. In that case, do not update
> the parent of x. But instead, skip over and continue the work. As x->parent
> would be the same as y->parent, instead of checking the x->parent (where x
> could be NULL), check y->parent, which is already known to be the same as
> x->parent if x is not NULL.
> 
> Also add another check_tree() at the end of the deletion routine.
> 
> Fixes: 5274db32a ("libtracecmd: Use an rbtree for mapping of cache pages")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357
> Reported-by: pierre.gondois@arm.com
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>   lib/trace-cmd/trace-rbtree.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-rbtree.c b/lib/trace-cmd/trace-rbtree.c
> index 24beabec..90671819 100644
> --- a/lib/trace-cmd/trace-rbtree.c
> +++ b/lib/trace-cmd/trace-rbtree.c
> @@ -314,7 +314,7 @@ void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *no
>   	struct trace_rbtree_node *x, *y;
>   	bool do_fixup = false;
>   
> -	if (!node->left && !node->right) {
> +	if (!node->left && !node->right && !node->parent) {
>   		tree->node = NULL;
>   		goto out;
>   	}
> @@ -329,9 +329,10 @@ void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *no
>   	else
>   		x = y->right;
>   
> -	x->parent = y->parent;
> +	if (x)
> +		x->parent = y->parent;
>   
> -	if (!x->parent) {
> +	if (!y->parent) {
>   		tree->node = x;
>   	} else {
>   		if (is_left(y))
> @@ -367,6 +368,7 @@ void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *no
>    out:
>   	node->parent = node->left = node->right = NULL;
>   	tree->nr_nodes--;
> +	check_tree(tree);
>   }
>   
>   __hidden struct trace_rbtree_node *trace_rbtree_next(struct trace_rbtree *tree,
