Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519FFC41513
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jul 2023 23:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjG1XgO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 19:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjG1XgN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 19:36:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522893AB4;
        Fri, 28 Jul 2023 16:36:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEF8A62207;
        Fri, 28 Jul 2023 23:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED89EC433C7;
        Fri, 28 Jul 2023 23:36:10 +0000 (UTC)
Date:   Fri, 28 Jul 2023 19:36:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sang QianLong <hacksonsang@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>
Subject: Re: [Issue of trace-cmd] undefined symbol when import ctracecmd.so
 in python
Message-ID: <20230728193609.79e91e44@rorschach.local.home>
In-Reply-To: <CANF=BhZScysm9BchEFytPgOFR4Gx-jeeOV6VpbKnAHZ102onSQ@mail.gmail.com>
References: <CANF=BhZScysm9BchEFytPgOFR4Gx-jeeOV6VpbKnAHZ102onSQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


I'm Cc'ing the trace users and devel mailing list just to keep this
archived.

On Fri, 28 Jul 2023 11:29:26 +0800
Sang QianLong <hacksonsang@gmail.com> wrote:

> Dear rostedt,
> 
> I hope this email finds you well. My name is Hacksonsang, and I am reaching
> out for your assistance regarding a persistent issue I am facing while
> working with "ctracecmd.so" in Python.
> 

I have to admit that I personally do not use python, and this code was
added by others.

Note, there's patches to fix the python code, but as I'm not a python
expert, I'm still holding off to applying them.

Not sure if this helps you, but you may want to look at this:

  https://patchwork.kernel.org/project/linux-trace-devel/patch/Y+w51nOhNd+PGo/k@slm.duckdns.org/

Does the above help you?

-- Steve


> I am currently using Ubuntu 20.04 with GCC 9.4.0 and Python 3.8.8. The
> problem arises when I try to import "ctracecmd.so" into my Python script. I
> consistently encounter the error message: "Undefined symbol: uncompress."
> 
> To address this, I initially attempted to include the "-lz" flag in
> LD_FLAGS, hoping to resolve the "uncompress" issue. However, this action
> resulted in encountering more "undefined symbol" errors, such as
> "tep_plugin_kvm_get_func."
> Upon investigating further, I found that these symbols are defined in the
> "trace-xxx.c" files within the "tracecmd" directory. Unfortunately, it
> appears that the Python/Makefile only utilizes the ".c" files from the
> "lib/trace-cmd" directory during the compilation of "ctracecmd.so." To
> address this limitation, I tried compiling "ctracecmd.so" by including the
> ".c" files from the "tracecmd" directory using "-fpic" compilation.
> Despite these efforts, I am still facing the same issue, and the "undefined
> symbol" errors persist.
> 
> Given the situation's complexity, I am seeking your expertise and guidance
> in resolving this matter. I believe that resolving this problem is crucial
> as the functionalities offered by trace-cmd are vital for the successful
> execution of my project.
> 
> If there are any specific steps or configurations that I missed or any
> other troubleshooting suggestions you could provide, I would greatly
> appreciate it. Please let me know if you require any additional
> information, logs, or code snippets to understand the issue better. I am
> willing to provide whatever is necessary for a comprehensive analysis.
> 
> Thank you so much for your time and consideration. I am eagerly looking
> forward to your valuable insights and assistance.
> 
> Best regards

