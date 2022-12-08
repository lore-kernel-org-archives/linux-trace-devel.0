Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D77AC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Dec 2022 12:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiLHMFO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 07:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLHMFN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 07:05:13 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.160])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A50880DA
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 04:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1670501105;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=EPOt6XZXpKOlpmuZv5Ijy6zEY25YXtgGlQuRDgSYot4=;
    b=iCzZ/BxJBdQK1dlU2TRu+9kzCZjIIQBVXyVz3udEjddwdTP4gYwDzycww2Z+n422+o
    Thn5kiV8fcgaxbwsKbisQe9gcm9f9zMud8Qvz78IWzcRutp9DLfDQApbpsk0pBV39F9A
    f5oE5/sJpqR5glYnDFBJVNuq/JtJQoEJkM/m77CcDKjF0rfoTfP1ZdlsvFcHtZVlp7+7
    PR+lO7PcnX/5mSCdQ2ZDCw5qVopvON+t+jC5zDCQXbUF1SzExmheWsI3/9uXg2kysXTX
    2LjmbOu/aspdPHC3LdpSVuie8ZZRNz/05a83sQp+TNFp5ctusQtxI4ODirfD06ot/+WM
    Em2w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSeBwhhSxarlUcu05JCAPyj3VPAceccYJs0uz"
X-RZG-CLASS-ID: mo00
Received: from blinux
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id z9cfbfyB8C55dPi
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 8 Dec 2022 13:05:05 +0100 (CET)
Message-ID: <02721f85812a264d1e45cdc8164d73da55b4fa39.camel@iokpp.de>
Subject: Re: [PATCH] libtracefs: Fix wrong return value in
 tracefs_tracing_dir_is_mounted()
From:   Bean Huo <beanhuo@iokpp.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Bean Huo <beanhuo@micron.com>
Date:   Thu, 08 Dec 2022 13:05:04 +0100
In-Reply-To: <20221206161314.73ecbfd2@gandalf.local.home>
References: <20221128132106.291101-1-beanhuo@iokpp.de>
         <20221128102410.5ccf784d@gandalf.local.home>
         <e6c020fc59cd3a2333806fbaf2a90092866fb7b7.camel@iokpp.de>
         <20221128133715.288fb265@gandalf.local.home>
         <20221206161314.73ecbfd2@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2022-12-06 at 16:13 -0500, Steven Rostedt wrote:
> On Mon, 28 Nov 2022 13:37:15 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ah, I think I see the issue here. If it returns NULL, then we need
> > to do
> > more. I'll take a look into this later today.
> 
> Can you test this patch?
> 
> Thanks,
> 
> -- Steve
> 
> diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
> index 777912e46821..d91ff40eee87 100644
> --- a/src/tracefs-utils.c
> +++ b/src/tracefs-utils.c
> @@ -245,7 +245,7 @@ const char *tracefs_tracing_dir(void)
>  	if (tracing_dir)
>  		return tracing_dir;
>  
> -	tracing_dir = trace_find_tracing_dir(false);
> +	tracing_dir = find_tracing_dir(false, true);
>  	return tracing_dir;
>  }
>  
> @@ -263,7 +263,7 @@ const char *tracefs_debug_dir(void)
>  	if (debug_dir)
>  		return debug_dir;
>  
> -	debug_dir = trace_find_tracing_dir(true);
> +	debug_dir = find_tracing_dir(true, true);
>  	return debug_dir;
>  }
>  


yes, it also works, thanks!

Kind regards,
Bean

