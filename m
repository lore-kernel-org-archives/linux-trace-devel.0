Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF0BC41513
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Aug 2023 13:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbjHBNsJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 09:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjHBNrz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 09:47:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2AE26B7;
        Wed,  2 Aug 2023 06:47:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3AD661935;
        Wed,  2 Aug 2023 13:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FC3C433C8;
        Wed,  2 Aug 2023 13:47:52 +0000 (UTC)
Date:   Wed, 2 Aug 2023 09:47:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sang QianLong <hacksonsang@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>
Subject: Re: [Issue of trace-cmd] undefined symbol when import ctracecmd.so
 in python
Message-ID: <20230802094751.49906f34@gandalf.local.home>
In-Reply-To: <CANF=BhYAbU+sLYxpaRVA=m0_jgJFr0c+JAAx+HQ4FcTkuSnB7w@mail.gmail.com>
References: <CANF=BhZScysm9BchEFytPgOFR4Gx-jeeOV6VpbKnAHZ102onSQ@mail.gmail.com>
        <20230728193609.79e91e44@rorschach.local.home>
        <CANF=BhYAbU+sLYxpaRVA=m0_jgJFr0c+JAAx+HQ4FcTkuSnB7w@mail.gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2 Aug 2023 16:13:20 +0800
Sang QianLong <hacksonsang@gmail.com> wrote:

> Hi Steven,
> Thanks for reaching out to me. I appreciate your effort in helping me with
> my persistent issue while working with "ctracecmd.so" in Python.
> 
> I understand that you personally do not use Python, and the code was added
> by others. I also appreciate your honesty in not applying the patches yet
> since you are not a Python expert. I have used the patch from
> https://patchwork.kernel.org/project/linux-trace-devel/patch/Y+w51nOhNd+PGo/k@slm.duckdns.org/
> and it works!
> 
> Once again, thank you for your help.
> 

I could add it with a:

Tested-by: Sang QianLong <hacksonsang@gmail.com>

if you are fine with that.

-- Steve

