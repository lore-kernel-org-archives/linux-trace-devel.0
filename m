Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5192C32771
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 01:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiIVBmz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 21:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiIVBmy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 21:42:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D204FAB199
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 18:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1E1562DCD
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 01:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8DDC433D6;
        Thu, 22 Sep 2022 01:42:49 +0000 (UTC)
Date:   Wed, 21 Sep 2022 21:43:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: README: Add note on installing
 libtracecmd
Message-ID: <20220921214351.1547ed52@gandalf.local.home>
In-Reply-To: <20220815031342.775201-2-joel@joelfernandes.org>
References: <20220815031342.775201-1-joel@joelfernandes.org>
        <20220815031342.775201-2-joel@joelfernandes.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 14 Aug 2022 23:13:42 -0400
"Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:

> This might be obvious but it still took me some Makefile reading. Add it
> to README to make it easier for others.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Both patches applied. Thanks Joel!

-- Steve

> ---
>  README | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/README b/README
> index 9d8c127..e823843 100644
> --- a/README
> +++ b/README
> @@ -57,6 +57,9 @@ To install trace-cmd
>  To install the gui
>      make install_gui
>  
> +To install libtracecmd libraries
> +    make install_libs
> +
>  Note: The default install is relative to /usr/local
>      The default install directory is /usr/local/bin
>      The default plugin directory is /usr/local/lib/trace-cmd/plugins

