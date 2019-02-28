Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C94C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 19:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CD920C01
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 19:10:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="l5RZhBdl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387413AbfB1TKk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 14:10:40 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36465 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733284AbfB1TKj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 14:10:39 -0500
Received: by mail-qt1-f194.google.com with SMTP id p25so24860716qtb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Feb 2019 11:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=+TfQWGMGs5ObBJodcOfCCLLfPFDT3yxUHkAF1a8U5pg=;
        b=l5RZhBdloG5SnuEpC7J80qco08NL6zfZAxkTcaznq32CSbl1Fl6HOIZVB1gb1Ig5GQ
         jfTPJz7YCH03JwzA0V2LbbykTqcoCFl5npJinI6Sap8KFNy9Q2Wl2JLj60qIBeQR3RsG
         IShrGDzKjjlNM3Uu7Z0Ze64W0J0mLEhX/+Uec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+TfQWGMGs5ObBJodcOfCCLLfPFDT3yxUHkAF1a8U5pg=;
        b=I/ND0+g7UvTsSqlFML58/8WnfVSM0QTSPjgpWJoEXucuwkZUcbM02IFQC2h0KcQywl
         nIKEcK9WIjb7vmRTQgD8yz+lyHLsutb4w9whdQcS2IF6iWvJg4LUjCXgY1mv+DvXn4XD
         6bDI839iKfv0QJ5QWxCmeBuY0TPDlGnunr0zp/YrpIcVj15PHE5FKBB7IoKSQSq5OV+m
         XjElJd8traJrCfgN1rdPaBPiyLAm7aMLsId8l1AIK7a+OCTifR40yVb7JpaBSBtTIx4Z
         xCSSyxk13MNagNWY+iT+KPqiDYDhwfFi1k8qd8+Rkj51Yf6cay2BG9T+reJTn6jrWG2L
         loNg==
X-Gm-Message-State: APjAAAXV71XN7tBM7rbTzH24Vv0fl7X3OGDL71nnb6YAVWT+CScg78SA
        ieXha7/fPcza844QwcnLBzE+Gw==
X-Google-Smtp-Source: APXvYqy+TEco/RrLJg0x6DwgujHE/KEmoQqB+GMeGU4Nek5SZHYM7shD34UwjLyEuaMVNk9ZcC2VqQ==
X-Received: by 2002:a0c:d121:: with SMTP id a30mr657202qvh.0.1551381038318;
        Thu, 28 Feb 2019 11:10:38 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id n21sm11413235qtl.97.2019.02.28.11.10.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 11:10:37 -0800 (PST)
Date:   Thu, 28 Feb 2019 14:10:36 -0500
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc:     Qais Yousef <qais.yousef@arm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        gregkh@linuxfoundation.org, Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        mhiramat@kernel.org, paulmck@linux.vnet.ibm.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, yhs@fb.com
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190228191036.GA203889@google.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <20190228135343.23kzkilig3bsioov@e107158-lin.cambridge.arm.com>
 <20190228144759.GA156098@google.com>
 <b100f0a2-7966-b6a2-dcd5-ca11abe57ead@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b100f0a2-7966-b6a2-dcd5-ca11abe57ead@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 28, 2019 at 05:04:59PM +0100, Dietmar Eggemann wrote:
[...]                      ^
> kernel/kheaders_data.h:1:1: note: in expansion of macro ‘KH_MAGIC_END’
>  KH_MAGIC_END;
>  ^~~~~~~~~~~~
> kernel/kheaders.c: In function ‘ikheaders_read_current’:
> kernel/kheaders.c:38:12: error: ‘kernel_headers_data’ undeclared (first use
> in this function); did you mean ‘kernel_headers_data_size’?
>             kernel_headers_data + KH_MAGIC_SIZE,
>             ^~~~~~~~~~~~~~~~~~~
>             kernel_headers_data_size
> kernel/kheaders.c:38:12: note: each undeclared identifier is reported only
> once for each function it appears in
> kernel/kheaders.c: In function ‘ikheaders_init’:
> kernel/kheaders.c:31:10: error: ‘kernel_headers_data’ undeclared (first use
> in this function); did you mean ‘kernel_headers_data_size’?
>   (sizeof(kernel_headers_data) - 1 - KH_MAGIC_SIZE * 2)
>           ^
> kernel/kheaders.c:57:23: note: in expansion of macro
> ‘kernel_headers_data_size’
>   proc_set_size(entry, kernel_headers_data_size);
>                        ^~~~~~~~~~~~~~~~~~~~~~~~
> kernel/kheaders.c: In function ‘ikheaders_read_current’:
> kernel/kheaders.c:40:1: warning: control reaches end of non-void function
> [-Wreturn-type]
>  }
> 
> 
> The reason for me to stay on v4.20 is that with v5.0-rc8 I don't have ebpf
> 'raw tracepoint' support any more on my arm64 board. But this issue is not
> related to your patch though.

I'm glad mainline fixed your issue though as you said in the other thread ;-)
I will refer to your email here later when doing backports if I hit the issue.

> Another point which supports the functionality your patch provides is the
> fact that maintainers don't want to see new TRACE_EVENTs in their code. So
> here your patch comes handy when using ebpf for tracing in embedded
> environments.

Yes, I agree. One can also use the series to build custom kernel modules
which can also contain tracepoints in their own right. Glad you also find it
useful. I will CC you on it for next spin.

thanks,

 - Joel

