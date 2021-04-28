Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B52C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B907961077
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhD1HwL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1HwK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:52:10 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0CEC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:51:25 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id z16so3232518pga.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FLIUxzD3Si1X1mYgaQKNLG2hbIGzfVnJ4XkFIlL3NN0=;
        b=OscKmwPAzy0hE+V075eNsMOEDfeBtyjI5VSpOWgiFfNEB3ae4bWlDdCV+SoRVO6P6J
         rseNJYzylytZJer6PjLQb2YA4TayQgiRX2F2LljOasBxKXkEhuVaJQIDy6jtboCA/Kry
         cCp6/xe2+Pkmr7kLDP+f9I8OoRWSEptXzjdopWeO2T+0vPLz0fjWSSHNMgqTgphlBiIb
         hBkIffstoV34s7XUR+eD21i2kZ2uHAkb2H6DQxrBNX0EJ9sQBqEP3TrNmugrt/0vUk00
         PWnMawvVRV1WtXrUuQueCcdH0B9nvp8uNyyAXhN+IdIcG3zdYzD/p6UbNief/9CJ9lz/
         N7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FLIUxzD3Si1X1mYgaQKNLG2hbIGzfVnJ4XkFIlL3NN0=;
        b=INsF0x+dFhG3xkytmWfAuHFwSzFMqoxO+8+L9KJJesQ8DRLzek5KuooKnxkXiYacIF
         TTDGjaxoYNdD30OgOSKuKCmKcJ0zY9Ds6JFVA2+WEcZvoAaWItM612IT55xqGg2TQ5Fg
         oQeP9HLNb1k+mH4oWoOsj9X2D7qaA6MfbMR02H0s5eJhiNNuSL4vhNDEOa7SpUWa6cuQ
         tnKx5sRCpAS8ZZ9lpIvebWxN38Ji7kwVsik2kyb9MCUcAb5RETF5AamDSTyst95m3kDL
         eOeRCKs/H/X1/dErNs6c2RVWIBcH2dSLzjlSShB9msudVKf/TORDeCsEhe8AX8TYk9NY
         CH6w==
X-Gm-Message-State: AOAM532AQttKHJw/onIVR+tI2vUzZmgzzvdtvBhxqjj/ClzAagAtbYZK
        vRzu59oDF6GW7seclJ9PfjCxwWldPchlVEdZxfxcA7LAKz+z/Q==
X-Google-Smtp-Source: ABdhPJwzdDo3EIeVyQclTYfEO6EQglTd7s8uvDoSKdXs7Ti2IW9E2J6Zd0AmZk81/bQ4w9YLyXF25rpEFhs6whdPbAQ=
X-Received: by 2002:aa7:8051:0:b029:272:7b9c:cde1 with SMTP id
 y17-20020aa780510000b02902727b9ccde1mr19369218pfm.55.1619596285430; Wed, 28
 Apr 2021 00:51:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210415080316.3482986-1-tz.stoyanov@gmail.com>
 <20210415093428.1a3a1678@gandalf.local.home> <CAPpZLN7ZvgSKoNVek+msCHarKY7F-dYUhKSuoKt_DF2qaE_rwg@mail.gmail.com>
 <20210416095908.258d4c96@gandalf.local.home> <20210416100118.585d3865@gandalf.local.home>
 <20210422162525.495e2d17@gandalf.local.home>
In-Reply-To: <20210422162525.495e2d17@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 28 Apr 2021 10:51:09 +0300
Message-ID: <CAPpZLN4cA1CdT1tNLNpTUzvzp5qp=4QjEH=gLMuBb0cqO_jE9A@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Suppress trace library warnings
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 22, 2021 at 11:25 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 16 Apr 2021 10:01:18 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Fri, 16 Apr 2021 09:59:08 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > >
> > > As for pr_stat(), I think we should rename it to tep_info() and tep_vinfo()
> > > that acts just like tep_warning(), except it is for informational output
> > > (stdout instead of stderr). This is similar to what the kernel has.
> > >
> > > Since tep_vwarning() takes a name, so can tep_vinfo(), and I was thinking
> > > that we should expose this string to the application.
> > >
> >
> > Oh, and we could add a tep_critical() and tep_vcritical() which means that
> > the error is something really bad happened, (like failed to allocate).
>
> Any thoughts on this?

The "[PATCH 0/8] Changes to trace-cmd logs" patchset supersedes this.


>
> -- Steve



--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
