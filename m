Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656BFC433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Jan 2021 00:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D11664DD4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Jan 2021 00:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhA1AYV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhA1AV4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Jan 2021 19:21:56 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB54C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Jan 2021 16:21:16 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id 36so3588105otp.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Jan 2021 16:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=PlqpzMMVsrTDfB0W1NMWykZ8LXmGLQsYceol3rgBXdk=;
        b=pfUjzFnc2djngIzzWapTyh2/iEIKIttBymd9DoO8bpXDF/Q4PJ/5ecbPB0SYaiWxk9
         MzBwSZcnbWM7Wn4odlX4dbc0RgpBbM8FzcEd/NHlkFsPAm2FrSlq+ZhPBq1INkeh30/z
         CXSYDjSd0JaLeHsmsoImvd5r7HbiUsaDZtBxHbOrjhgUuA4FSsuR8ijjHBbUobc/y+Wn
         Retsbm07c2r/2aggZMe3eGaFCGOdjoW2T/uMghfeosmLRHwZrzlGGjD6NV5e5eW5CD8p
         FULZsfeEi7b/SSDnUksoyA9+pK7gp7bF+vR+oa51wRILZLbjIxbWxnzrwBqTzSeIrD9p
         4cvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=PlqpzMMVsrTDfB0W1NMWykZ8LXmGLQsYceol3rgBXdk=;
        b=qRsb3RkVARzTOG4iFCA2SRg7JB9C2od/iHo34yduseCIFQpyweSP0vIjvqEOCi+C+W
         YBHeEtPwAOaeDFSYCN2JwMQxLHXWjarcSsPSqtturEITED7MoO3yzHO1oeXfeL7fDSnc
         Oh5No2El00ayiDTjhvwBt82ft7xS0Oo/TqlbwayZHh3+M16sEqEZR7+yRMdjQbHzGeDz
         uX6K1TnZjNmow3TtiFbb8atMQJKk0q9L3AAoUgNL4XdwSJeRoTE52YPHHqlmU69ueyfF
         YtLr+OjyeGcJFGxzLfCixZ3K0aN3R3cQWUMDlI97c5lWcxIMofdlUutL5sXjfnhqb+nJ
         MVOQ==
X-Gm-Message-State: AOAM531poFRlL0Bg4w2KbBJ72TmY9VYU3+K9AWFv6whEslnAHKWOhTNs
        06Mdeb4wPFO6bJcSQbnLb9TR2Wm3/sVbglehOfOTHPgxEzCoHA==
X-Google-Smtp-Source: ABdhPJzB3nG3XEBpyTrmpBGsAMRcpbQiaaEi6vi+3idM1WzEJalG6LRu3B5lOshADz9BtcvB6ufExdM7GkOGPbo3q14=
X-Received: by 2002:a9d:664d:: with SMTP id q13mr9437715otm.156.1611793275598;
 Wed, 27 Jan 2021 16:21:15 -0800 (PST)
MIME-Version: 1.0
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Thu, 28 Jan 2021 11:20:38 +0530
Message-ID: <CAK7tX=akBmqBDUZ1k6dDd9aZ=xoTwppBiEa21wQomME-vQzv7g@mail.gmail.com>
Subject: libtracefs: New APIS to write/erase 'set_ftrace_filter' and
 'set_ftrace_notrace' Inbox
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

hi,
I am working on the below API's
----------------------------------------------------

Add an API to set filtering of functions:

int tracefs_function_filter(struct tracefs_instance *instance, const
char *filter);

Which would write into the set_ftrace_filter file for the instance.

Also have a:

int tracefs_function_notrace(struct tracefs_instance *instance, const
char *filter);

That would write into the set_ftrace_notrace file for the instance.

Have a:

int tracefs_function_filter_clear(struct tracefs_instance *instance);

That clears the set_ftrace_filter file.

and a:

int tracefs_function_notrace_clear(struct tracefs_instance *instance);

That clears the set_ftrace_notrace file.
----------------------------------------------------------

Bugzilla link: https://bugzilla.kernel.org/show_bug.cgi?id=210643

if there is anyone already working on these API's please let me know.

Thanks,

sameer.
