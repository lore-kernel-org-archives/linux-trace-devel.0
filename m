Return-Path: <SRS0=DbCI=BH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C3EC433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jul 2020 12:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCF8020714
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jul 2020 12:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595938751;
	bh=aOGbvtFJknnPLZnhNAmwX9mOcIr5xiO1WU/L5dMwtXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eV6zqDimfzqF4wzEMHQZDVb41rqkMfyFIEkLB7/oxI6s4ztem1NX5xFZAg+c3pTNG
	 e+T/54+uyabjsRLuoAQY52VWJxgmly3OpmldXcHmVCPvRdrAS70wNt9i5lRgA3BcKj
	 hHJ1v79G0tBaRYSl43irWgjlr5FjjcYnvT2aWVWY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgG1MTL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 08:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728736AbgG1MTL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 08:19:11 -0400
Received: from quaco.ghostprotocols.net (179.176.1.55.dynamic.adsl.gvt.net.br [179.176.1.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF99F206D8;
        Tue, 28 Jul 2020 12:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595938751;
        bh=aOGbvtFJknnPLZnhNAmwX9mOcIr5xiO1WU/L5dMwtXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wZvgIXfq/p6Iye0A6jwHWMw3WH5WWXNIVN4xIOx215xIxR3/554X/4L0s8v0d6U24
         LWWiydQaZLJOpxX/D5MD5hnR9IcdpNillj6erJaDi6Es55owkfl8cRMddxwkFtCgKz
         tFKeqeq6fSuiQDMRuGd9sdFTByhxY9XVPjgI54gc=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 2B2A6404B1; Tue, 28 Jul 2020 09:19:08 -0300 (-03)
Date:   Tue, 28 Jul 2020 09:19:08 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Fix build with binutils 2.35
Message-ID: <20200728121908.GG40195@kernel.org>
References: <20200725010623.GA194964@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725010623.GA194964@decadent.org.uk>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Sat, Jul 25, 2020 at 02:06:23AM +0100, Ben Hutchings escreveu:
> In binutils 2.35, 'nm -D' changed to show symbol versions along with
> symbol names, with the usual @@ separator.  When generating
> libtraceevent-dynamic-list we need just the names, so strip off the
> version suffix if present.

Steven, have you seen this one?

- Arnaldo
 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable@vger.kernel.org
> ---
>  tools/lib/traceevent/plugins/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/plugins/Makefile b/tools/lib/traceevent/plugins/Makefile
> index 349bb81482ab..680d883efe05 100644
> --- a/tools/lib/traceevent/plugins/Makefile
> +++ b/tools/lib/traceevent/plugins/Makefile
> @@ -197,7 +197,7 @@ define do_generate_dynamic_list_file
>  	xargs echo "U w W" | tr 'w ' 'W\n' | sort -u | xargs echo`;\
>  	if [ "$$symbol_type" = "U W" ];then				\
>  		(echo '{';                                              \
> -		$(NM) -u -D $1 | awk 'NF>1 {print "\t"$$2";"}' | sort -u;\
> +		$(NM) -u -D $1 | awk 'NF>1 {sub("@.*", "", $$2); print "\t"$$2";"}' | sort -u;\
>  		echo '};';                                              \
>  		) > $2;                                                 \
>  	else                                                            \



-- 

- Arnaldo
