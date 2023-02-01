Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06556C38142
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Feb 2023 19:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjBATbz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Feb 2023 14:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjBATby (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Feb 2023 14:31:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9020683250
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Feb 2023 11:31:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EBCD6192C
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Feb 2023 19:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C02CC4339B;
        Wed,  1 Feb 2023 19:31:47 +0000 (UTC)
Date:   Wed, 1 Feb 2023 14:31:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Johannes Schauer Marin Rodrigues <josch@mister-muffin.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] rtla: Fix cross building
Message-ID: <20230201143144.37b258c2@gandalf.local.home>
In-Reply-To: <20230120070809.6169-1-josch@mister-muffin.de>
References: <20230120070809.6169-1-josch@mister-muffin.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 20 Jan 2023 08:08:09 +0100
Johannes Schauer Marin Rodrigues <josch@mister-muffin.de> wrote:

> For a successful cross-build, the host-architecture version of
> pkg-config must be used or otherwise host architecture headers of
> libtracefs and libtraceevent will not be found.
> 
> Signed-off-by: Johannes Schauer Marin Rodrigues <josch@mister-muffin.de>
> ---
>  tools/tracing/rtla/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
> index 22e28b76f800..26ebd46ec29c 100644
> --- a/tools/tracing/rtla/Makefile
> +++ b/tools/tracing/rtla/Makefile
> @@ -18,7 +18,7 @@ endef
>  $(call allow-override,CC,$(CROSS_COMPILE)gcc)
>  $(call allow-override,AR,$(CROSS_COMPILE)ar)
>  $(call allow-override,STRIP,$(CROSS_COMPILE)strip)
> -$(call allow-override,PKG_CONFIG,pkg-config)
> +$(call allow-override,PKG_CONFIG,$(CROSS_COMPILE)pkg-config)
>  $(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
>  $(call allow-override,LDCONFIG,ldconfig)
>  

I don't usually have pkg-config as part of my cross build path. I have just
overridden it to use different commands, by defining the variable of
PKG_CONFIG, but I have not had any issues. But my compiler path never
included pkg-config.

-- Steve
