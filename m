Return-Path: <SRS0=osWp=TH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B69C004C9
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 May 2019 17:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04F2A2053B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 May 2019 17:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="OrB1lgi2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfEGRRl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 May 2019 13:17:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46743 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfEGRRl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 May 2019 13:17:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id t187so4506874pgb.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 May 2019 10:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sXiQJbpi/4IGaaTOVq7540dm+WX0y+kDeTKOVgV+NMk=;
        b=OrB1lgi2e5zENC5xyWyvWQlBbafJaPk/dhSP7eqEOwgN+g5epKpCynLaNInuOffPJW
         Y7KfBhVuc8GkA09O1V0m+yT89l3VxpB/ZlVa9qyXaEuMndK09H1aFyf4VlsFjogHEAuA
         EoV8tJOUg8v067Z5ptBuIe5cHUyjWDL3LjqH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sXiQJbpi/4IGaaTOVq7540dm+WX0y+kDeTKOVgV+NMk=;
        b=W4nNiYw2U4FpWdeyiGP/pTDWjxgOA39nifFipIzMJ5OJpbXypwEB+y9AUHk6Mq87ZD
         XMNQn9O0i1bpkZSWvPxUr/lN0iCKg0fkLZwioRARAxZ9zQ5PUhZRSYDz1PvylVALJH6r
         mKIlK8To20yITTWgLA76ng3sCxTNrItxBkTwiAzC8KJYczld85EZVBC+c2QtRdiDWpvZ
         f26MA33We6Tv+7zZd8IVCaYr6CyHselbZbwnOq+lZNo4WSsQQvrrb6//RhvNmUZSHj1B
         llR2kB3P12lY1tbt8zwVCwPicwlrjfE3hpzW1kXm7bZoy5hev+p/QbggnrSulteYY1RV
         8pKQ==
X-Gm-Message-State: APjAAAUldcFltB4EikLS9Gvp+2aS3CfZTXNgepeR8BqYvbfTdtqhE6+5
        Y1ZDbFF8r9vN22tB/g00XVo/TA==
X-Google-Smtp-Source: APXvYqznkP0ThPErDNtnYUHloyF7dhrTadAsD2R/2MqVYWQNALgwqZGdhqOdOSCT6tsWXaWn7VHKDw==
X-Received: by 2002:a63:1701:: with SMTP id x1mr40730723pgl.153.1557249460626;
        Tue, 07 May 2019 10:17:40 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id s19sm16914559pfe.74.2019.05.07.10.17.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 10:17:39 -0700 (PDT)
Date:   Tue, 7 May 2019 13:17:37 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, atishp04@gmail.com,
        bpf@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>, dancol@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dan Williams <dan.j.williams@intel.com>,
        dietmar.eggemann@arm.com, duyuchao <yuchao.du@unisoc.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        =?utf-8?Q?Micha=C5=82?= Gregorczyk <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>,
        Olof Johansson <olof@lixom.net>, qais.yousef@arm.com,
        rdunlap@infradead.org, Shuah Khan <shuah@kernel.org>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>, yhs@fb.com
Subject: Re: [PATCH v2] kheaders: Move from proc to sysfs
Message-ID: <20190507171737.GA97358@google.com>
References: <20190504121213.183203-1-joel@joelfernandes.org>
 <20190504122158.GA23535@kroah.com>
 <20190504123650.GA229151@google.com>
 <20190505091030.GA25646@kroah.com>
 <20190505132623.GA3076@localhost>
 <20190505163145.45f77e44@oasis.local.home>
 <20190507163824.GC89248@google.com>
 <20190507165718.GA1241@kroah.com>
 <20190507130333.58c95268@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507130333.58c95268@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, May 07, 2019 at 01:03:33PM -0400, Steven Rostedt wrote:
> On Tue, 7 May 2019 18:57:18 +0200
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > > Thanks makes sense. So Greg, I submitted this properly, does it look good to
> > > you now? Steven, I would appreciate any Acks/Reviews on the patch as well:
> > > https://lore.kernel.org/patchwork/patch/1070199/  
> > 
> > Looks good to me, should get to it in a few days...
> 
> Me too. Feel free to add
> 
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> But as for reviewing, I see nothing wrong with it, but I doubt I'll
> find something that Greg missed in this code.

Thanks!

 - Joel

