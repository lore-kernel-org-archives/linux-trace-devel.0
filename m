Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25835210C2B
	for <linux-trace-devel@vger.kernel.org>; Wed, 16 Oct 2024 16:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729097455; cv=none; b=kJ038vxEKoXGFiLigRMefYPQmCn2K5PMnwEj18NwBQKst5vnVEdhd3RtBFDU8NfMnCPGCBEo4ePq68cKv/fojzI2DjzKQ4tWUpTg+XFfr0GEjgCrXXgd3YFuWziuCU5dWW+eNrp6/zMyldL+Kk+VpFEQgG574tliHxe7rU+cU8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729097455; c=relaxed/simple;
	bh=jWUruk2j5MHuHrjlQ2dCm2+7+iALNRtxg5c2w6HQbx4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KnStG0H032Q5ZHCocA8+KRKtoNRAaivcHtENTmD4z7wZwjacTE2pCQ80/bQGUvWDiRnaQSny0Iax7B4NefQuhzMdodZt7RsOPo0vCl6QuOVSzGrO1XE32sTjTuNQvQ0RT8E2ynBF673qUkPYr9TROQJgdsJzQ4yWG408FJ+wdrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57405C4CED0;
	Wed, 16 Oct 2024 16:50:54 +0000 (UTC)
Date: Wed, 16 Oct 2024 12:51:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs .gitignore: Ignore utest/trace-utest in git
Message-ID: <20241016125115.4f48dc88@gandalf.local.home>
In-Reply-To: <20241015154502.4189900-1-metin.kaya@arm.com>
References: <20241015154502.4189900-1-metin.kaya@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Oct 2024 16:45:02 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

I'm applying this, but even the most trivial patches must have a commit
log. There should never be an empty commit log (except for whitespace and
spelling fixes).

I added this:

    The test program utest/trace-utest is created by "make test" and should
    not be tracked by git.

-- Steve


> Signed-off-by: Metin Kaya <metin.kaya@arm.com>
> ---
>  .gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 3e72a58..7e61473 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -13,3 +13,4 @@ tfs_version.h
>  *.o
>  .*.d
>  sqlhist
> +utest/trace-utest

