Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEAAC432C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 14:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DFD321774
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 14:51:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2kjEVF1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfK1Ovs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 09:51:48 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:42060 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfK1Ovs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 09:51:48 -0500
Received: by mail-io1-f67.google.com with SMTP id f25so3099902iog.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 06:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MEK43psFTFfG5djdFZBDO+VxrjizNrOyyGCHHKDbfpE=;
        b=U2kjEVF1EVV+XntUatclWWqUiZ0DTR0k8IDo0JnUWAZhMdy7Gm12hIjeU9XRCjY2H2
         EF8QitwyghllK/LiJesuRGsFshrhtFhpQhuPB+ynUc7Eq2T4lEl2oJs1FGSKXlGeZDXl
         Xfhx69dFhJcueLl/jor+BwdPpfNbTH3P25/uGHSn3aj4l8Dvhq/EkvGePnB2lGGJ873/
         ei/dzyXuINmsFSQnvZbnzt6o62h8L7zKgwinTIvTILk02FMiISreVXXx2xEnozuILVvr
         R86vuSJRuMVwyma//QndGcHDAqg9XiOO03Aar5ZAWy4Jrrg0JgnomX9kqmkA1boD7mv7
         00TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MEK43psFTFfG5djdFZBDO+VxrjizNrOyyGCHHKDbfpE=;
        b=rFjUn48dLUeu8nizGLV1lSKnNJmVMpY/BXxZg/4rULvd3Uw+qlhf+j1QS/EE4KrYxL
         xqVpfHl9zmqtGa21wWNGht2WQDCX7pB0KP1AVMl2Icy0GL1Uh0l5n10fxfPGkgsk/n1I
         JP5FUzvy+84YGILyEBEBRrfr/SsSvQnnpOvKLyMbvLbr+2fh6auyQ/Bakwl1cpv6luiq
         +DGlokMozuWXCCoUh3r+DL+A+hK2uRaWnU9z7742Gyrv/vL4dQv6g55YeNNJDqgd9NS1
         Y68gFRfhRHWqcKJKqHPqv2LwBz6Ck9HyQUAtvl7j3iwdOCpOLVnCMNjP8r+CLfdxMRLc
         tS3g==
X-Gm-Message-State: APjAAAVfs5eq+4MhBIPI+rdEzvJtk3p4ygvxf0dU1I4HPhCwRRYA6BQl
        F18LfyxTh751cDZ/GAwmN9lUsDvvosE3Irg+qw==
X-Google-Smtp-Source: APXvYqy36b40v63nrMdXplG6lNO0ggGBBLCu80onVoyF6YaUkjwlAe/kGihcM7ctmyl4Q/DNwFZkcTccRNTTwcac8/M=
X-Received: by 2002:a6b:c305:: with SMTP id t5mr42340856iof.87.1574952706963;
 Thu, 28 Nov 2019 06:51:46 -0800 (PST)
MIME-Version: 1.0
References: <20191128085409.289684-1-tz.stoyanov@gmail.com> <20191128085409.289684-16-tz.stoyanov@gmail.com>
In-Reply-To: <20191128085409.289684-16-tz.stoyanov@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Thu, 28 Nov 2019 16:51:35 +0200
Message-ID: <CAE0o1NupdFjJLnQ1dKVEUh91_fBiTt1nok+_7mLiOSZpcbFGKg@mail.gmail.com>
Subject: Re: [PATCH v15 15/18] trace-cmd: Refactor few trace-cmd internal functions.
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 28, 2019 at 11:01 AM Tzvetomir Stoyanov (VMware)
<tz.stoyanov@gmail.com> wrote:
>
> In order to reuse code inside trace-cmd application context,
> few functions are made non static:
>         int make_vsock(unsigned int port);
>         int get_vsock_port(int sd, unsigned int *port);
>         int open_vsock(unsigned int cid, unsigned int port);
>         char *get_guest_file(const char *file, const char *guest);
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/include/trace-local.h | 8 ++++++++
>  tracecmd/trace-agent.c         | 4 ++--
>  tracecmd/trace-record.c        | 8 ++++----
>  3 files changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index a6f79c5..17ef31a 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -19,6 +19,8 @@
>  #define GUEST_FIFO_FMT         GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
>  #define VIRTIO_FIFO_FMT                "/dev/virtio-ports/" GUEST_PIPE_NAME "%d"
>
> +#define TRACE_FILENAME         "trace.dat"
> +
>  /* fix stupid glib guint64 typecasts and printf formats */
>  typedef unsigned long long u64;
>
> @@ -258,6 +260,12 @@ void tracecmd_disable_tracing(void);
>  void tracecmd_enable_tracing(void);
>  void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
>
> +int make_vsock(unsigned int port);
> +int get_vsock_port(int sd, unsigned int *port);

trace-agent.c is not getting compiled if VSOCK isn't defined so those
functions won't be available then. Put them undef #ifdef VSOCK here
too? Or have all vsock functions in a separate .c file, #ifdef-ed so
that those functions do nothing when VSOCK is not defined?

> +int open_vsock(unsigned int cid, unsigned int port);
> +
> +char *get_guest_file(const char *file, const char *guest);

Cheers,

-- Slavi
