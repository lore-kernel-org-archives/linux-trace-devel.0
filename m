Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF93C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Dec 2021 06:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242820AbhLVGvP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Dec 2021 01:51:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239297AbhLVGvP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Dec 2021 01:51:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640155874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ch2Xpj1pnRLF55Cf/9agxcFXuNqtmtfpr9anTXKKzF0=;
        b=CoiMsn53WqYTqKPi1iJOBd+xoCcn+MALUrzFdOy/GeGs5UJr9whe1e2fGsKs91Myl/O+13
        X4D4uIU5xkHjs6NCVFVZdZDSZ3kl4JjpWrvfZlqSoaxdb44m0FnKWMhTaPqGOYWzDf9sfz
        CHLwFdJRNJJOEiiD1Y6SelFPGPvIMJo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-qzO1JpoUMBuuJREYuuMX6A-1; Wed, 22 Dec 2021 01:51:13 -0500
X-MC-Unique: qzO1JpoUMBuuJREYuuMX6A-1
Received: by mail-wr1-f71.google.com with SMTP id p1-20020adfba81000000b001a25b07ff53so415408wrg.22
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Dec 2021 22:51:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ch2Xpj1pnRLF55Cf/9agxcFXuNqtmtfpr9anTXKKzF0=;
        b=oReVhgHR4/DFM5Htoy5EMHud4n3Zhv3E1Rd1z797cs/WkWxeIMDhNjCEfBiLEmDh8a
         Wd0JXFW1T4+rBTJa+Yubz1rMSs9CX2pbLplWoXqOd9l/Kg+y/A21MoEnAgeaa3xfX6n9
         xpLggF27ktVObGErcNQtcovBvSc2ehG1Anh/uWH3w3osSR0MgFAecknngAu0d+N1jnyd
         +DjbtYzXuvq9Id1NN1DCf5Q1xxVF4ry6HdWAQHduKwBvk2ZXI90Fq3zquJ62XKTMmzCP
         okeySeH0klu32wg6O/TW4cUNzFGPp45apCj2BWFFTTpG+ILs7jeO/UKjaHuBwD5KLrw2
         YOgw==
X-Gm-Message-State: AOAM533/i3x7Rd60DOr+NT5RlxhY3vw+k8NMktiT6tw75z4Wur7G7iEK
        bRXBVRVPDUCdPyPS2nQNIlNSc3NfSlkKAW3OPWAj3b1zSPy883kF4z9sjCABN6rw1C49DLMYsOs
        WrZacOaLVYGJCsykjsFS/8i4/dAQSGBg=
X-Received: by 2002:a7b:c4d3:: with SMTP id g19mr1124856wmk.46.1640155871822;
        Tue, 21 Dec 2021 22:51:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDtNRmO6B8NSDYghPyCIuC7SMgE+EpTU/PA6KZoEqMErn7wwJ2gVK2teXs+Zth65RDz/bQuQ==
X-Received: by 2002:a7b:c4d3:: with SMTP id g19mr1124841wmk.46.1640155871637;
        Tue, 21 Dec 2021 22:51:11 -0800 (PST)
Received: from localhost.localdomain ([151.29.58.184])
        by smtp.gmail.com with ESMTPSA id g8sm685827wmh.17.2021.12.21.22.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 22:51:10 -0800 (PST)
Date:   Wed, 22 Dec 2021 07:51:08 +0100
From:   Juri Lelli <juri.lelli@redhat.com>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tao Zhou <tao.zhou@linux.dev>
Subject: Re: [PATCH V9 00/14] RTLA: An interface for osnoise/timerlat tracers
Message-ID: <YcLK3MXdFTwYYC7O@localhost.localdomain>
References: <cover.1639158831.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1639158831.git.bristot@kernel.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi!

On 10/12/21 19:11, Daniel Bristot de Oliveira wrote:
> The rtla(1) is a meta-tool that includes a set of commands that
> aims to analyze the real-time properties of Linux. But instead of
> testing Linux as a black box, rtla leverages kernel tracing
> capabilities to provide precise information about the properties
> and root causes of unexpected results.
> 
> To start, it presents an interface to the osnoise and timerlat tracers.
> In the future, it will also serve as home to the rtsl [1] and other
> latency/noise tracers.
> 
> If you just want to run it, you can download the tarball here:
>   - https://bristot.me/files/rtla/tarball/rtla-0.5.tar.bz2
> 
> To compile rtla on fedora you need:
>   $ git clone git://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git
>   $ cd libtraceevent/
>   $ make
>   $ sudo make install
>   $ cd ..
>   $ git clone git://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git
>   $ cd libtracefs/
>   $ make
>   $ sudo make install
>   $ cd ..
>   $ sudo dnf install python3-docutils procps-devel
>   $ cd $rtla_src
>   $ make
>   $ sudo make install
> 
> The tracing option (-t) depends some kernel patches that are
> available at [2].

FWIW, I took this for a spin (on RT) and had a very positive experience
with it. Think is does what it says on the tin and makes using osnoise
and timerlat tracers easier.

Please feel free to add

Tested-by: Juri Lelli <juri.lelli@redhat.com>

Best,
Juri

