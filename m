Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764F9257B
	for <linux-trace-devel@vger.kernel.org>; Fri, 17 May 2024 00:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715907184; cv=none; b=JSnkTcwqjHh1IszhX369UXokaeni+J7SwujriQgDOrtVuDkdh2GThFKJJ5wwt8CnJc4kAdnes372NA0jyqDwtvs3YHfG6GhCDR+x04PAxDl8/AFQ9Uf4CznB1vZGClWMzq/Ft0Dz1KpCKq2TW9TlPE3diz0BdG1fXaarvM0KYb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715907184; c=relaxed/simple;
	bh=XftNFvamk365qzqEakwX4IG1AAkvfsFIGV6lZXI/foo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Muri1vNhXcfYfemj3PxpV/bYzYbxB7rKrrHAtpVng44OIGrECpHYPKK6ejZYCx/0WjvdLCYye4Cp2MYWO0vWVFFiFqAoNpbqTw0TAHI7ES9lmAPW4d8W9NBi4YL/cXjGouj21unrteOCy1gfPntfi/Y0CJVx1HvU+santatDTDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C357BC113CC;
	Fri, 17 May 2024 00:53:03 +0000 (UTC)
Date: Thu, 16 May 2024 20:53:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jianfeng Wang <jianfeng.w.wang@oracle.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Add ftrace options with fgraph retval
 option
Message-ID: <20240516205302.0cf9640d@rorschach.local.home>
In-Reply-To: <20240415154921.4998-3-jianfeng.w.wang@oracle.com>
References: <20240415154921.4998-1-jianfeng.w.wang@oracle.com>
	<20240415154921.4998-3-jianfeng.w.wang@oracle.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Finally got the time to look at these patches ;-)

On Mon, 15 Apr 2024 08:49:21 -0700
Jianfeng Wang <jianfeng.w.wang@oracle.com> wrote:

> +++ b/lib/trace-cmd/trace-ftrace.c
> @@ -23,6 +23,12 @@ struct tep_plugin_option trace_ftrace_options[] = {
>  		.description =
>  		"Show the depth of each entry",
>  	},
> +	{
> +		.name = "retval",
> +		.plugin_alias = "fgraph",
> +		.description =
> +		"Print function retval at function exit in function graph",
> +	},

Honestly, I don't think this should be an option. Or if it is, it
should be default on. If the retval exists in the trace, it should just
be printed. Why ask the user to show it when they spent the time to
enable it in the recording?

Thanks!

-- Steve

>  	{
>  		.name = NULL,
>  	}
