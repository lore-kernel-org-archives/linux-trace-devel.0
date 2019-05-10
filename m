Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049A0C04A6B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 21:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7AF0217F9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 21:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vLHYryG1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfEJVZR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 17:25:17 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:35600 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbfEJVZR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 17:25:17 -0400
Received: by mail-vs1-f67.google.com with SMTP id s4so4504791vsl.2;
        Fri, 10 May 2019 14:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:message-id;
        bh=IRTLh3UNu7SPuTbbI61OV5Ow9SpRxjKSzwT3uHWMX5E=;
        b=vLHYryG1zs0J79YjN8Wnu86cKnSSweIlY7wAFbYr0Gkw9IVnfa3UZ4conX/ssCuQe3
         3Zw0ulCI5lV17hSPlfZIX64stAfNLQXqlYU4u1fZW/Cw2F7UdknEiVkRa9Vy/df87LAx
         QJY38l/A1SLiOb7p01rLhw1/AkenHssqx5CCU4jEJZxNy88AUS/ED+vuOtSVLTL4Yrdj
         z4h5UCK/bsb1BejX8ZGdSS2igIrjghgWcuFio7LurvtdNdYvwGPuxR62SJVMzy+3tyng
         dQYNLLWWAIgZi7Eoy33eQtqH4Ze/J0Q+LvJMbphi0AYDzYQqVoTogQEe592mz2Ny3jpZ
         iXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:message-id;
        bh=IRTLh3UNu7SPuTbbI61OV5Ow9SpRxjKSzwT3uHWMX5E=;
        b=ljcUTz2xWV4DhIUn/zfczPRswZZpkzgQVj4coWyvatVfKDWAtjWT8PWM1DOEIKzlXO
         nqCGJpEPTkrUKRM4btgQc1ewL8J3mobTPCVXgWFa+iEhuMdGt6vZgSGdRAmrKTY+PDel
         AipeVB9CJYudSHuwGFSGlhMeC7fSgWKUyfWO8Yb8ktSxpWCGH66niBrF5/82Ef6yaQdR
         2lMQwuRvzlKaHZZY1N1/pGkrNHjM2yFOyJRdFKg0Flp3KulPFRMG9XgAnTx70tub+YD/
         skWdEb2Qm9JR5FH1hjwT2VSrPljhVIh+GGGf3ZWRenjoOAu955p8zwcPZ2hYxpgibL8n
         rXMg==
X-Gm-Message-State: APjAAAUUYxp0tZWO8fSsAn8PKnJ0Nue1Qvwynm/0m/7u8aaXzEDu/TMd
        rWukeUtoMdE3cs4W4sa5EiE=
X-Google-Smtp-Source: APXvYqwn00Lcp6Z3izxfZ3GTSCywUImOfkwdr8X6hPTssjctHERIhMSHNo/gEm/R0sT9rfBA6roaOQ==
X-Received: by 2002:a67:ea0b:: with SMTP id g11mr7351534vso.130.1557523515985;
        Fri, 10 May 2019 14:25:15 -0700 (PDT)
Received: from [192.168.1.113] ([199.116.59.166])
        by smtp.gmail.com with ESMTPSA id j71sm4117957vsd.0.2019.05.10.14.25.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 14:25:15 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Date:   Fri, 10 May 2019 17:25:10 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20190510161150.20be7f1e@gandalf.local.home>
References: <20190510195606.537643615@goodmis.org> <20190510200105.966709757@goodmis.org> <20190510161150.20be7f1e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 01/27] tools lib traceevent: Remove hard coded install paths from pkg-config file
To:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
CC:     Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <BDB00110-43B1-4766-BB21-D7BF6FDD5EC7@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On May 10, 2019 4:11:50 PM AST, Steven Rostedt <rostedt@goodmis=2Eorg> wrot=
e:
>On Fri, 10 May 2019 15:56:07 -0400
>Steven Rostedt <rostedt@goodmis=2Eorg> wrote:
>
>> From: Tzvetomir Stoyanov <tstoyanov@vmware=2Ecom>
>>=20
>> Install directories of header and library files are hard coded in
>> pkg-config template file=2E
>>=20
>> They must be configurable, the Makefile should set them on the
>> compilation / install stage=2E
>>=20
>> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware=2Ecom>
>> Cc: Jiri Olsa <jolsa@redhat=2Ecom>
>> Link:
>http://lkml=2Ekernel=2Eorg/r/20190418211556=2E5a12adc3@oasis=2Elocal=2Eho=
me
>> Link:
>http://lkml=2Ekernel=2Eorg/r/20190329144546=2E5819-1-tstoyanov@vmware=2Ec=
om
>> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis=2Eorg>
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat=2Ecom>
>
>Bah!
>
>I based my patch series off of the wrong commit, and ended up including
>this one in this series=2E
>
>Arnaldo,
>
>I believe you already applied patch 1 (otherwise I would not have your
>SOB on it), please ignore=2E But patch 2 on are new to be applied=2E


Ok, I'll be back at work early next week and will peixes this,

- Arnaldo

>
>Thanks!
>
>-- Steve
>
>> ---
>>  tools/lib/traceevent/Makefile                  | 13 +++++++++----
>>  tools/lib/traceevent/libtraceevent=2Epc=2Etemplate |  4 ++--
>>  2 files changed, 11 insertions(+), 6 deletions(-)

