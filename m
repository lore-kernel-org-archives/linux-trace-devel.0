Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0F6C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 15:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDE45205ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 15:08:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="MFvmRDDk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfECPIg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 11:08:36 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37911 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfECPIg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 11:08:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id j26so2868468pgl.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 08:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kNTkQVNOA2OoGY05E27L56yuHsdvzUwDV9bMvSlE76A=;
        b=MFvmRDDkIMtc9BaQDjrWPOSUDO9Jo1/wdFL+oMmuaFtd8BrX+9VVatnVk8YjQSnsoW
         BsziOIyoxXHvWBYgvME24AJwRTKzg1v5hpxTEyKu2vSeYGAOa5tUX3uW7FhbKDdETQyb
         5v+yKc70MV3v8Y806ihEUUkgJzSgITzNo64UQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kNTkQVNOA2OoGY05E27L56yuHsdvzUwDV9bMvSlE76A=;
        b=SYefyS67/Ae0n1ZhZFyvcA+aLEsHQ5vxBHvMnwhBQwzWhFJ8CIMMglj8UmYb5fRk1R
         pOmzrVHA1zYoG+jO4cTjNED79eh5/MBsWQR3zDZCxkLPsxgKEL0Vvyz7ZraYV8cTGooX
         bhHYlPeVZBcfBYZh81KwiyHJFS64iy9dBRSKpSs8tI2OmUpKSXOe+0TKUZ4D7/auNc7R
         S1Ma5vUyR/4wvFNHx5pm8rxt5Om6rZb1WXy7AU8zekjAUUu+9wNo2jFYFbI5VImVFxWg
         iV59i+l5DtR65dDJg2bJHVNeXXW+VaT48froueAt8lPQyYfnNSRrjrl/1Hs9glSUIuvq
         7JnQ==
X-Gm-Message-State: APjAAAVwanwnIgVPGg6/ahbUV16Im8Sneggrosko6ONXt10wa4epItVG
        UQaKvJvSEATRrWCM6cToiQ4N7w==
X-Google-Smtp-Source: APXvYqw24XwNGkccqq09Ydr+Lfzc0vUPYmCja1k9q/7RdUIA3TyzF/y1fhaSR7qOXsBcDbXc//83LQ==
X-Received: by 2002:a65:5c82:: with SMTP id a2mr11014324pgt.378.1556896108024;
        Fri, 03 May 2019 08:08:28 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id d3sm3262715pfn.113.2019.05.03.08.08.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 08:08:27 -0700 (PDT)
Date:   Fri, 3 May 2019 11:08:25 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v7 resend 1/2] Provide in-kernel headers to make
 extending kernel easier
Message-ID: <20190503150825.GC253329@google.com>
References: <20190426190430.172543-1-joel@joelfernandes.org>
 <20190427133844.GA29366@kroah.com>
 <20190429132602.GA165075@google.com>
 <20190429135455.GA2412@kroah.com>
 <CAK7LNARkGLQ_P4LSuC69QN8XPN47W5ujkDE3EauLrwnBgygsSA@mail.gmail.com>
 <20190429142425.GB29007@kroah.com>
 <20190503103315.0149ca71@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503103315.0149ca71@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 03, 2019 at 10:33:15AM -0400, Steven Rostedt wrote:
> On Mon, 29 Apr 2019 16:24:25 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > Hah, ok, I'll be glad to queue this up in my tree.  I'll take it now,
> > and if people who really object to this being in /proc/ and want it in
> > /sys/, we can add a follow-on patch before 5.2-final is out to move the
> > file to that location.
> 
> I really don't think putting it in /proc now is a good idea. Let's put
> it in /sys now. If we don't do it now and it gets into a main release,
> then that will become the permanent location for it.

I will send a patch to move it into /sys/kernel on top of this. Hope everyone
else is also Ok with that as the location.

thanks,

 - Joel

