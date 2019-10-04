Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F83C10F14
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 02:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2388C215EA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 02:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570157487;
	bh=WadsH0VeFXBFLZUgSubBR092HUR+Aw6DBFdsgbLszVM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=cwrDwXHfjuOff0nJLA51YncQPEyxuQurihv992EH0x43IwpAxDek5ReZb6yIeUfS3
	 kT4V1rTnjuFVIA6Bh8iQdUB2Rm9ON+s2naFpCBSY42kNwCEshP2SLmtufn7cVhW+OE
	 +Z37iw6MsSF+PgfSXlK5R7XZiE1PVmVdqaxW3ZJg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730982AbfJDCv0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 22:51:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40487 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730488AbfJDCv0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 22:51:26 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so4166355wmj.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Oct 2019 19:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WadsH0VeFXBFLZUgSubBR092HUR+Aw6DBFdsgbLszVM=;
        b=lH9SnSpTK72P1HHtSs0FxYPCM51rasNpmgZowLvlDE0TucLUexhp66r6YwAkwEYSD2
         vu0utqS/MJ8b4sF0a6DYMfK5PA9E5NDM7msJFCxyGkQJrqtcpQ6zliSRf4qnh1HmaxZw
         enTN80Zh5KGXs0K5jXkXleazloLgsvQy13XAP7X1p9Bk9nSVikA6hdT0Mky7/L7HNkrK
         xZ8c9i2xpDBUM+PG1yVGJJMZnCIxswO+vbZeP8VDROo+1hzyjo2Z0q2wl/lTUc75WQi5
         189Qf3O3lCXBl076YAi20khcu6MGpcOY5vlCE9GznkatVbx5wuHd+GacHlw5zSaSq9xZ
         2tgw==
X-Gm-Message-State: APjAAAUT8WvfCn4w0IozwqzfeClPnFKgT2RLfNgyenckZ0oSgD0cyaUh
        WZheF/9Y55wWb8rCWGoziVCTB57hZgim0MeNW9g=
X-Google-Smtp-Source: APXvYqwTmC7C37DRHdOrYuGLD7Tb0WFwZdf+pcJs9w0icgaxvq9YNTie4caNcBvnesE4WeOOt1+y30WZ6wZRpfxQ6zI=
X-Received: by 2002:a7b:c44d:: with SMTP id l13mr8491312wmi.160.1570157483630;
 Thu, 03 Oct 2019 19:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <20191003150104.74216a0a@gandalf.local.home>
In-Reply-To: <20191003150104.74216a0a@gandalf.local.home>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Fri, 4 Oct 2019 11:51:12 +0900
Message-ID: <CAM9d7ciT2NtY9_m_scxom-POvKJR_LV-JaCxC+B78dc=DezuzQ@mail.gmail.com>
Subject: Re: Getting libtraceevent into a packaged library
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Patrick McLean <patrick.mclean@sony.com>,
        John Kacur <jkacur@redhat.com>,
        Alan Mikhak <amikhak@wirelessfabric.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Tony Jones <tonyj@suse.de>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Nivedita Swaminathan <nivedita.swaminathan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Fri, Oct 4, 2019 at 4:01 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> What's the next step to get this into a package so that perf,
> trace-cmd, power-top, rasdaemon, uftrace, and whatever does not need to
> have its own copy of the code, but instead link to it.
>
> Note, the interface has changed since other tools copied it, and I'm
> willing to help anyone out in porting to the package.

For uftrace, I think it needs to keep the copy of the code for a while
since it should support older versions of distros as well.
I'll add a runtime dependency check for libtraceevent and use
the new APIs if exists.

Thanks,
Namhyung
