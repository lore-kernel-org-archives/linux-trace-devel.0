Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B131A1CFB6
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Oct 2024 00:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730335654; cv=none; b=lgaheyEDALrAbl6r93Ymz5JUCeK8Rohe0DmiPv/NyesVtTMnwWfgZ+0LlMIvDyIT0Bc7BKzlY2LDKw9kUxKz1KNQBYnGK6VCrSmiml+rDKWbpC/QREwXB1iBrj5ScjOZfRcoj9C1mPUB22pIAWHthZl0yb+EMAWQYojz6o1fIVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730335654; c=relaxed/simple;
	bh=J8+8RkSxJs6HLnMShQqPUJzwcvoYnEC7SBZknNfl93M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=URsKM7EHPWlxDtzjPvUC39ZIrWE44dGedyrxYzLFBGXpw7BWTMBJSs9f6hpIj1F3tYROt/AXfiFQLXZp9WhDoljFwp+H6tKQT9hy2lX/u09nh+OV721P5iRBo9n/p+ue1L3yzES7NbJLFBtvsfco857+fXaHRGe7GCn3GEms+Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91C8C4CECE;
	Thu, 31 Oct 2024 00:47:33 +0000 (UTC)
Date: Wed, 30 Oct 2024 20:47:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Douglas Raillard
 <douglas.raillard@arm.com>
Subject: Re: [PATCH] trace-cmd: libtracecmd: Rename private functions to fix
 static building
Message-ID: <20241030204731.69d656d8@rorschach.local.home>
In-Reply-To: <20241028122247.1594967-1-metin.kaya@arm.com>
References: <20241028122247.1594967-1-metin.kaya@arm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Oct 2024 12:22:47 +0000
Metin Kaya <metin.kaya@arm.com> wrote:

> Building trace-cmd statically fails because of duplicated symbols for
> strstrip() function which is also implemented in libtracefs. The
> __hidden attribute does not resolve these conflicts for static builds
> due to the lack of namespacing support in C. Refer to the associated
> Bugzilla page [1] for further details.
> 
> Although only strstrip() breaks the static build as of now, we should
> fix the underlying issue comprehensively across the libtraceevent,
> libtracefs, and trace-cmd packages. The recommendation on [1] is
> prepending package name (e.g., "tracecmd_") to private functions (tagged
> with __hidden attribute).
> 
> Thus:
> 1. Retain private functions which already start with "tracecmd_".
> 2. If a private function starts with "trace_", then just change its
>    prefix to "tracecmd_".
> 3. If prepending "tracecmd_" prefix to a private function's name clashes
>    with an existing one, rename one of the functions per its context
>    (e.g., rename trace_load_plugins() to
>    tracecmd_load_plugins_from_handle() and trace_append_options() to
>    tracecmd_append_options_to_file()).
> 4. Prepend "tracecmd_" prefix to all remaining "__hidden" functions.
> 
> Future __hidden functions should follow this prefixing schemed to avoid
> new naming conflicts.

I'm not against the change to make the hidden functions with a unique
name, but I rather come up with something other than "tracecmd_". That
prefix was to be used for functions that will eventually become public.

Would "tcmd_" work?

Same goes for the other libraries. The "tracefs_" is for functions that
should be exported. Perhaps rename it to "tfs_"?

As for libtraceevent, it doesn't need a separate prefix for local
variables compared to exported ones, but that prefix is "tep_" and not
"traceevent_".

-- Steve
