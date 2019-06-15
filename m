Return-Path: <SRS0=aZJ0=UO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF334C31E47
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jun 2019 10:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AA432184B
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jun 2019 10:26:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vzo5oCNF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFOK0f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jun 2019 06:26:35 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33043 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfFOK0e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jun 2019 06:26:34 -0400
Received: by mail-oi1-f196.google.com with SMTP id q186so3835546oia.0
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jun 2019 03:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DfY7yT974KLRFDL/wz4MGvRYybHKI9/E2XqBGSIlyLQ=;
        b=Vzo5oCNFTQTtaR727JifUSzQ2p9tQP+7ygup1tXI1jQeZFMHSpVIBicMiV8JsxV+dp
         62R0/vBB27iIw8pfoc49JpaPbYW2kBwvZ7QxZtIY5KNIpvXcDKmr6KKvYTiPnk7riXZo
         aZ1Sd1rORmvJfIu5Bokt/q9Suq6zwjD2stVWxwpVDnmj0r7RWzyGEqY5K4q9qG7WmiWr
         MUfe+96Z89bEMviIqXm9KllNQXDXRd/0d62BLhz3u80jvLBo7QxQUthdbDC0X0yUzxdj
         EtbXE2XpFeGTSGcAciqyBLeE2VpdTDRFHCQta19G2XoO2AgiAzk2x9VGDZZxzOsMIXgZ
         CDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DfY7yT974KLRFDL/wz4MGvRYybHKI9/E2XqBGSIlyLQ=;
        b=DKNLDoA2H1vKsvRdrPr3yTFHEe6NyS7QiBKEh7/4dNG3L4eWr5k93a3aeaovBIgGk6
         kx2Tdp2xZ2/XwRiUiQMXj6I2M/+aveFbN7t52FjDVMPd6k8XWQ4c0tMMgw4jIqtK6/ei
         sc/R1noOuLV5gTnczH0tG88sMRMpBoFol+pPX8I0FjRyqxd6nyg/jJ6VtE59+mOsWOGv
         VklaXaNp8QoKglurOx4dPZr8Fyj828F432FoEALavlvWmgIIfcm5zGDpjI8huds+zZT0
         cJFYCxQ2La7cRmo0YLrF0ckZoWsXZuBP8A3Rlpkc9nsFuCMSejD3f9kM73cqK61R33j6
         NtVA==
X-Gm-Message-State: APjAAAUHVyC82kL4PO1IkNTFDKw52IW760TgLPCp3OMM4QpIisDm3BHb
        rxA74DzAWzM8f/c1JdNYKZ4gTPYHDHvI2i0+kQG+gt7h
X-Google-Smtp-Source: APXvYqzz1YDR0Bw6DVssbcOdTrQaAh+BWGx/eGQi/W1eH40ovqzTS++ed8FzC5v7VcBthFezz2LpiScdDBPvIKr3k3A=
X-Received: by 2002:aca:51cf:: with SMTP id f198mr4809710oib.140.1560594393449;
 Sat, 15 Jun 2019 03:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190614135045.17223-1-ykaradzhov@vmware.com> <20190614135045.17223-4-ykaradzhov@vmware.com>
In-Reply-To: <20190614135045.17223-4-ykaradzhov@vmware.com>
From:   Alan Mikhak <alanmikhak@gmail.com>
Date:   Sat, 15 Jun 2019 03:26:22 -0700
Message-ID: <CAOY98NeyG3HD-94SUC5+=iivi8rcw_3Vo8ESKrKz91X2DMCa6Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] kernel-shark: Fix all warnings when building on 32
 bit systems
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jun 14, 2019 at 6:51 AM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> Fixing warnings coming from:
> ../examples/datahisto.c
> ../src/KsTraceGraph.cpp
> ../src/libkshark.c
>
> Reported-by: Alan Mikhak <alanmikhak@gmail.com>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/examples/datahisto.c |  4 ++--
>  kernel-shark/src/KsTraceGraph.cpp | 10 +++++-----
>  kernel-shark/src/libkshark.c      |  4 ++--
>  3 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/kernel-shark/examples/datahisto.c b/kernel-shark/examples/datahisto.c
> index 02c6285..b177b08 100644
> --- a/kernel-shark/examples/datahisto.c
> +++ b/kernel-shark/examples/datahisto.c
> @@ -56,11 +56,11 @@ void dump_bin(struct kshark_trace_histo *histo, int bin,
>                 puts ("EMPTY BIN");
>         } else {
>                 entry_str = kshark_dump_entry(e_front);
> -               printf("%li -> %s\n", i_front, entry_str);
> +               printf("%zd -> %s\n", i_front, entry_str);
>                 free(entry_str);
>
>                 entry_str = kshark_dump_entry(e_back);
> -               printf("%li -> %s\n", i_back, entry_str);
> +               printf("%zd -> %s\n", i_back, entry_str);
>                 free(entry_str);
>         }
>
> diff --git a/kernel-shark/src/KsTraceGraph.cpp b/kernel-shark/src/KsTraceGraph.cpp
> index da2c6aa..324f36e 100644
> --- a/kernel-shark/src/KsTraceGraph.cpp
> +++ b/kernel-shark/src/KsTraceGraph.cpp
> @@ -277,7 +277,7 @@ void KsTraceGraph::_resetPointer(uint64_t ts, int cpu, int pid)
>         QString pointer;
>
>         kshark_convert_nano(ts, &sec, &usec);
> -       pointer.sprintf("%lu.%06lu", sec, usec);
> +       pointer.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
>         _labelP2.setText(pointer);
>
>         if (pid > 0 && cpu >= 0) {
> @@ -313,7 +313,7 @@ void KsTraceGraph::_setPointerInfo(size_t i)
>         uint64_t sec, usec;
>
>         kshark_convert_nano(e->ts, &sec, &usec);
> -       pointer.sprintf("%lu.%06lu", sec, usec);
> +       pointer.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
>         _labelP2.setText(pointer);
>
>         comm.append("-");
> @@ -601,17 +601,17 @@ void KsTraceGraph::_updateTimeLegends()
>         QString tMin, tMid, tMax;
>
>         kshark_convert_nano(_glWindow.model()->histo()->min, &sec, &usec);
> -       tMin.sprintf("%lu.%06lu", sec, usec);
> +       tMin.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
>         _labelXMin.setText(tMin);
>
>         tsMid = (_glWindow.model()->histo()->min +
>                  _glWindow.model()->histo()->max) / 2;
>         kshark_convert_nano(tsMid, &sec, &usec);
> -       tMid.sprintf("%lu.%06lu", sec, usec);
> +       tMid.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
>         _labelXMid.setText(tMid);
>
>         kshark_convert_nano(_glWindow.model()->histo()->max, &sec, &usec);
> -       tMax.sprintf("%lu.%06lu", sec, usec);
> +       tMax.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
>         _labelXMax.setText(tMax);
>  }
>
> diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
> index 0f0a1ba..9aaf1b7 100644
> --- a/kernel-shark/src/libkshark.c
> +++ b/kernel-shark/src/libkshark.c
> @@ -1423,7 +1423,7 @@ char* kshark_dump_custom_entry(struct kshark_context *kshark_ctx,
>         event_name = info_func(kshark_ctx, entry, false);
>         info = info_func(kshark_ctx, entry, true);
>
> -       size = asprintf(&entry_str, "%li; %s-%i; CPU %i; ; %s; %s",
> +       size = asprintf(&entry_str, "%" PRIu64 "; %s-%i; CPU %i; ; %s; %s",
>                         entry->ts,
>                         task,
>                         entry->pid,
> @@ -1472,7 +1472,7 @@ char* kshark_dump_entry(const struct kshark_entry *entry)
>                 event_name = event? event->name : "[UNKNOWN EVENT]";
>                 lat = kshark_get_latency(kshark_ctx->pevent, data);
>
> -               size = asprintf(&temp_str, "%li; %s-%i; CPU %i; %s;",
> +               size = asprintf(&temp_str, "%" PRIu64 "; %s-%i; CPU %i; %s;",
>                                 entry->ts,
>                                 task,
>                                 entry->pid,
> --
> 2.20.1
>

Hi Yordan,

I had to manually apply your two patches from 2019-06-14 manually on top of your
first patch from 2019-06-12. I was able to build KernelShark on my
Raspberry Pi 3
model B+ and observe that your combined changes resolved the abort issue as
well as compiler warnings. I also observed the same good results on my
ODROID-XU3
from hardkernel.com which also runs a 32-bit armv7l kernel as well as
my 96Boards
ROCK960 model C which runs a 64-bit aarch64 kernel.

Please see bugzilla for an attached patch file which shows the
combined changes I
manually applied as your patches intended.

Regards,
Alan
