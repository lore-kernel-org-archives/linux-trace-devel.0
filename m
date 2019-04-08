Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7724AC10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 20:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44DD720880
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 20:52:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=opersys-com.20150623.gappssmtp.com header.i=@opersys-com.20150623.gappssmtp.com header.b="xohJxEgQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfDHUwW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 16:52:22 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43908 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfDHUwW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 16:52:22 -0400
Received: by mail-qt1-f194.google.com with SMTP id v32so17175075qtc.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 13:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=opersys-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N14AhTxvpgKm7opomcskbJu240RmijliAlq/LQco5+M=;
        b=xohJxEgQh56evQpZH9Z6Tr+8QD+X5zrtlnIpIL9wkHOz6ED9WckyqKL8bWEMIij7vz
         pTJFeWpL6VCtzy8kQ/uDyaQfjPuRRNB9JszLtqNV3x3Aa656vEN2pkp8EHCYsiSVgSnb
         2MW6pWT0B53lHpJ8iuGR9cqcqU+KlZFjX2+oI+A0SOowjDzqZ66Yzq706777JXsD8inI
         HQtTAqzF7NPtDGcUxSKfXy2Ip7WDu2S9vXC9YfQCr0k/GypSp//U78KY/ez0O+wG6ay6
         dI2DZ5ePyXQxAgf+htbcEDSE6QiQo7b+4kyaJLrvCJOZ6if7FAxgXtvL48xhpxpK2ikD
         JA2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N14AhTxvpgKm7opomcskbJu240RmijliAlq/LQco5+M=;
        b=fkor4+cGpnOXm7SQU4mqtFKApALzqtblBZa01vRDs62oKB7/mBpdCvgxB9ixoK87zB
         IuswfWZBc5YohuzQgxOFPJbWerMGchZG4Qx3+0gkCqHm9klwZSFTQFja++fxJ8mWyJNa
         hIHDnsnQMvyMibCY0y5By6og8c2OtB294PoSTU6QJj5qJBNi86P+EAuBTNuxaMmBL+dG
         rXerNwIB7Lp7eeV/6lTsbf86rXXXQyfq46vE+IfkkSdLHqWvMMu4YSmbZ/wc79o7LxNZ
         SRv9tbMhB1v1tOYc+3w1uHMJ2jlIylbagfNeDFquteWUYVal2ViYtEc5fghQDQc5aOcV
         gSAg==
X-Gm-Message-State: APjAAAXpx7QCycSZbgJAtqJqwqrErR/QM67TE7a3v6gJD7CUeXT+cF4i
        8Nku8IMDYeP3G+q9qDY4JNf15w==
X-Google-Smtp-Source: APXvYqzpSaFSlvwadrWnQugCdiUpYK9xOsAJFWUpR+8zhpAw+HNabQJapK7e7ieAiq9HTIiwn/O0gg==
X-Received: by 2002:a0c:b15c:: with SMTP id r28mr25509887qvc.122.1554756741316;
        Mon, 08 Apr 2019 13:52:21 -0700 (PDT)
Received: from [192.168.202.103] (modemcable170.15-70-69.static.videotron.ca. [69.70.15.170])
        by smtp.googlemail.com with ESMTPSA id f47sm22032237qta.80.2019.04.08.13.52.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 13:52:19 -0700 (PDT)
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel
 easier
To:     Olof Johansson <olof@lixom.net>, joel@joelfernandes.org
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qais.yousef@arm.com, dietmar.eggemann@arm.com,
        linux@manojrajarao.com, Andrew Morton <akpm@linux-foundation.org>,
        ast@kernel.org, atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        mhiramat@kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, yhs@fb.com
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
From:   Karim Yaghmour <karim.yaghmour@opersys.com>
Message-ID: <79b6bdbc-890a-5a51-7fa1-aec57889046a@opersys.com>
Date:   Mon, 8 Apr 2019 16:52:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Olof,

On 4/8/19 12:29 PM, Olof Johansson wrote:
> Sorry to be late at the party with this kind of feedback, but I find
> the whole ".tar.gz in procfs" to be an awkward solution, especially if
> there's expected to be userspace tooling that depends on this
> long-term.
> 
> Wouldn't it be more convenient to provide it in a standardized format
> such that you won't have to take an additional step, and always have
> it in a known location?
> 
> Something like:
> 
>   - Pseudo-filesystem, that can just be mounted under
> /sys/kernel/headers or something (similar to debugfs or
> /proc/device-tree).
>   - Exporting something like a squashfs image instead, allowing
> loopback mounting of it (or by providing a pseudo-/dev entry for it),
> again allowing direct export of the contents and avoiding the
> extracted directory from being out of sync with currently running
> kernel.
> 
> Having to copy and extract the tarball is the most awkward step, IMHO.
> I also find the waste of kernel memory for it to be an issue, but
> given that it can be built as a module I guess that's the obvious
> solution for those who care about memory consumption.

One of the things I pointed out earlier in the thread is that 
/proc/config.gz has already set a precedent as to the interface for this 
sort of artifact. It's a plain compressed file and it's directly 
accessible from toplevel /proc. From a consistency perspective there's 
an idiomatic angle to some sort of "/proc/kheaders.gz".

In some offline discussions I was also told that squashfs (I'm no expert 
of it) required special user-space tools and had some security issues.

Cheers,

-- 
Karim Yaghmour
CEO - Opersys inc. / www.opersys.com
http://twitter.com/karimyaghmour
