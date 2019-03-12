Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A29CC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 15:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 386F12054F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 15:15:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=opersys-com.20150623.gappssmtp.com header.i=@opersys-com.20150623.gappssmtp.com header.b="nBwSQar2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfCLPP3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:15:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40004 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfCLPP3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 11:15:29 -0400
Received: by mail-pg1-f194.google.com with SMTP id u9so2056111pgo.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Mar 2019 08:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=opersys-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FZ2NM1YKpyJJZYoLdhw2cHDKJcHkXzpSBjLOhSn/aJ8=;
        b=nBwSQar2U7UBxqKU5ysnwQdbngSqBwZbx1rLquE03XH+omIkIDB/JnSPamjEmZev/6
         JI6bOCKtGC3hFMEenZfucVjnnjSwD0Qt0Xku47b+dix0VocOH6n89PF4Of68ylHzVXBU
         aSMTmgASqJuDc4w/eESpgd3+6SAAbEuNrEXN+3cWNM+XUFINWJJGGrrMBCTv3CxJZAR6
         cFriTPjIdxJ+sDWHTdfWWveGNmcrC9Ko2SrfRMkZRKM3Kx/a8NjwCrSqBLM68sdIjhio
         HH692zCjPrS6ANpYeA4JZrTU+sp+Ahq0GqE02zJWz293STCr+lmb9kjEyIJDYTlYRgXj
         fH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FZ2NM1YKpyJJZYoLdhw2cHDKJcHkXzpSBjLOhSn/aJ8=;
        b=mt5wj3PL+WY/ERSSpG4Dzk+ILzD3MJerm+tEw83INxeCywQ7h10yD4rKFUKsMWvBcA
         5hu18KyT4iL4s3OzcQa748XDS3atqqLILOFCQo5DB/++Q+zkXgheiZ9U8jen2jpm/J6x
         +QQM3xPZXmCO6LIgDwTKyDXnmp81FJJO5VdJ0K9qwCHtOnQVF89sEmGWd8EiIISjiQPo
         tOBYO+wW58XIK1d3hEzLs5c2cChAZx8jlIjy2jacZjrSkuzZvkkyXRdnlB+DQX2rX/co
         UYSYxr/TEH/y31Zg285PFwCr2dfGNvMI8dUO02kSUh5XlIRS8YEu756tnnsIlXJSXPx1
         RH/A==
X-Gm-Message-State: APjAAAXhfZyE713wqcjwtKbwdFl5jSkLwwb/XBoIh1mrH+CWga+9ugEz
        q1LmiE0QeLys4N/LeuBxQaW+lw==
X-Google-Smtp-Source: APXvYqy5WQS1SFVSZRve6EApYWu/gKMKXxkI3h8Xg5DNw1bxWpBdmRhMhGIYjIoh9zGGACdi7MZR9A==
X-Received: by 2002:a63:e952:: with SMTP id q18mr34355385pgj.156.1552403728323;
        Tue, 12 Mar 2019 08:15:28 -0700 (PDT)
Received: from [192.168.1.101] (mobile-166-171-249-100.mycingular.net. [166.171.249.100])
        by smtp.googlemail.com with ESMTPSA id a24sm12226917pfo.160.2019.03.12.08.15.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 08:15:27 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com>
 <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
 <20190308140251.GC25768@kroah.com>
 <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
 <20190309071648.GE3882@kroah.com>
 <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
 <20190309121141.GA30173@kroah.com>
 <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
 <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
 <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
 <CAMuHMdVw=b_oS70F1LhXV0b9fn_p6OuCo2RDUQC=49PdJVW7xA@mail.gmail.com>
From:   Karim Yaghmour <karim.yaghmour@opersys.com>
Message-ID: <a034919f-d4ca-b8f2-b80b-5de3d4606b97@opersys.com>
Date:   Tue, 12 Mar 2019 08:15:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVw=b_oS70F1LhXV0b9fn_p6OuCo2RDUQC=49PdJVW7xA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Geert,

On 3/11/19 4:03 AM, Geert Uytterhoeven wrote:
[ snip ]
> OK.
> 
> Now about the actual solution: what is your opinion on embedding e.g.
> a squashfs image in the kernel instead, which would be a more generic
> solution, not adding more ABI to /proc?

I'm not familiar enough with the intricacies of squashfs to have an 
educated opinion, but I hear that it's got its quirks (need for 
user-space tools, etc.) and possibly security issues. Also, I wonder 
whether it's a generalized solution that still kicks the ABI can down 
the road -- ultimately the kernel would still have a path/format/foo for 
making kheaders available in that squashfs image and that convention 
would become ABI. The only "benefit" being that said ABI wouldn't appear 
under /proc, and, tbh, I'm not sure that that's actually a benefit or is 
even idiomatic since kconfig.gz is already under /proc. To an extent, 
the precedent set by kconfig favors kheaders to also be available in the 
same location using a similar mechanism ... i.e. bonus points for 
consistency.

But that's my hand-wavy gut-reaction response to your question. I'm sure 
others on this thread have far more informed opinions about the 
specifics than I could have. My priority was to clarify the basis for 
the need being addressed.

Cheers,

-- 
Karim Yaghmour
CEO - Opersys inc. / www.opersys.com
http://twitter.com/karimyaghmour
