Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E2613342F
	for <linux-trace-devel@vger.kernel.org>; Thu, 31 Oct 2024 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730389187; cv=none; b=qNFtF03wtz34aFZ3oXdYi198ZwnRzS1MZL8adECVZc74kF5do3TueqzkKh5oW8uVY8yEVDFyx8ZtF0M0yWzemwaw43iMLzih9EOxn4craxnIA/U22ZNSz30tbT0A8hvWnX54wnhWraqVvJqDLDgE79BWnrJPZaXVefhyRJ2UYEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730389187; c=relaxed/simple;
	bh=CzzGaN3ig4nZV0vdnMNoSCG6KfO6Uiq6l4eHeRnLOxI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/x2cotTlLfRFxwRpTHk6MGfsVrDFAEh0X9/EjJJKtZygZLQj3uvik3BnOKKsK9PPCJCwLIpFXcTZ7m3eb1qL+6EyWpG1Y8ZEQC4z9GCfZwZ31QqoClYFrofSFBrrjJJVQ4LSuGWlTowL3uTMR4VRrDi2KjjNnnxGrpa3l6Xh2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D303C4DE13;
	Thu, 31 Oct 2024 15:39:46 +0000 (UTC)
Date: Thu, 31 Oct 2024 11:40:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Douglas Raillard
 <douglas.raillard@arm.com>
Subject: Re: [PATCH] trace-cmd: libtracecmd: Rename private functions to fix
 static building
Message-ID: <20241031114042.7b43ec0e@gandalf.local.home>
In-Reply-To: <d95d6af4-75bb-44da-a479-045556141559@arm.com>
References: <20241028122247.1594967-1-metin.kaya@arm.com>
	<20241030204731.69d656d8@rorschach.local.home>
	<d95d6af4-75bb-44da-a479-045556141559@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 31 Oct 2024 09:48:32 +0000
Metin Kaya <metin.kaya@arm.com> wrote:

> > As for libtraceevent, it doesn't need a separate prefix for local
> > variables compared to exported ones, but that prefix is "tep_" and not
> > "traceevent_".  
> 
> I believe I did not rename any variables in the libtraceevent patch [1].
> However, I made the following changes in the libtracefs patch [2]:
> 
> -extern const struct tep_format_field common_stacktrace;
> +extern const struct tep_format_field tracefs_common_stacktrace;
> 
> -extern pthread_mutex_t toplevel_lock;
> +extern pthread_mutex_t tracefs_toplevel_lock;
> 
> Do you recommend keeping them as is or using "tfs_" prefix?

Might as well make the change. At least that tells us it's exposed across
files in the library.

-- Steve
