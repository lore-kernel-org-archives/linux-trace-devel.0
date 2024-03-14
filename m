Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF821A38D3
	for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2024 16:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710434474; cv=none; b=D/OE8oEicndPBCjseVbeMXxO93opffBLLpkxRHTHFH3QbjI9342dl9EU5wkJZ5rBwR25xOG9CtVUghlo0lHLnSTbpuf3OpdOD4t2BHNb3Z3f2aY0+mZc/nDWR2Tk1FVG7Px1POWkiKc5CzK2sz7oXpNFzuxBJVCIynqmvyh3Z+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710434474; c=relaxed/simple;
	bh=DSs3kmsvACL6mccBQVYDWNUz+D87/6x2fzrLiXQhRqk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZqUMrmZ+5ZPnDCK6tRBLHJiTIfzX9Odg+56+mKBKsyh4ovW6xyFYjvQ0Xa1uD5ZsNxcT3t6EZbNZSJBGhGb9UYW9gnGDFKJTJD8AL9/CtVSW5b9NQY0qvKWZsjCneg7bFr0Yu4fOr31YYYaVmWy91inrWbX7ssqB8zsc85ERi9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEB6C43390;
	Thu, 14 Mar 2024 16:41:14 +0000 (UTC)
Date: Thu, 14 Mar 2024 12:43:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Aleksander Trofimowicz <trof@n90.eu>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs meson: Use SemVer in the build description
Message-ID: <20240314124324.1f9cc481@gandalf.local.home>
In-Reply-To: <87v85okco4.fsf@mx.n90.eu>
References: <87v85okco4.fsf@mx.n90.eu>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 Mar 2024 16:20:43 +0000
Aleksander Trofimowicz <trof@n90.eu> wrote:

> Meson adheres to RPM rules while exercising version
> sorting. Therefore 1.8 < 1.8.0; Meson-driven builds of trace-cmd
> are broken since b86599e459 since a dependency requirement
> cannot be met.

Thanks,

Note, I'm currently focusing on the Linux kernel as the merge window is
still open. I'm hoping to start working again on the user space tooling
next week.

-- Steve


> 
> Signed-off-by: Aleksander Trofimowicz <trof@n90.eu>
> ---
>  meson.build | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/meson.build b/meson.build
> index 3156f1c..91ee79a 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -6,7 +6,7 @@ project(
>      'libtracefs', ['c'],
>      meson_version: '>= 0.50.0',
>      license: 'LGPL-2.1',
> -    version: '1.8',
> +    version: '1.8.0',
>      default_options: [
>          'c_std=gnu99',
>          'buildtype=debug',
> --
> 2.44.0
> --
> at

