Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BDBC432C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 15:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C31BD21741
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 15:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pF+Okb93"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfK1PIV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 10:08:21 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41954 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1PIV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 10:08:21 -0500
Received: by mail-io1-f68.google.com with SMTP id z26so25766360iot.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 07:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wFtuY7YYlsGiV8Od2WZGKXiaaer2N+uRT4+cyDkYcgI=;
        b=pF+Okb93YfJaSmD3ZNezr4LrsWU19V1Mpd3N51lJbLKZ4I0yvbTljVTCl5Qh9eP4Uc
         R1Vb4k9K/saUqvus6meCMg+rD7ksrwKZm92Jm6cRS3nHHvSsh9KR9QLgmC++DTXhekc7
         60GFfRO0/otwt3qtWS0tx8eghIWTtKpRCfz1+OjhvYOHugVQindPiW/CQVdzSqPCGKmj
         caNlvYnl01vSCbDZbVPQdjVtYw6YhqlYpABM2edAIgY6hMrUsc033X0YPQTvTiHpmhPa
         mL1lqx/FzplmoiOf++OAA44J5EJqEHy4FtWPOBsam9wtteGyeWOupHBLygR4/oOaqsEn
         H9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wFtuY7YYlsGiV8Od2WZGKXiaaer2N+uRT4+cyDkYcgI=;
        b=uEFfpEmSJqqsWmsXbHUFXqZm95Ojbdd0esapga7fx9YYwhy1X0pdJK749eAVkE8gn1
         xRAn24B+A0UnTtaBo3F9+MCKz75azoym4QrqG4np1rBvTqCKy4TmOvhKV5EpCLwrkjHm
         ZKVYLM1Pmfst8sbDipWWkhY0tjTpdRdB4iMUIGiv4EpymIOu4nxvVjksQjhBJ4PeGKJB
         3nXutkQKIUOyZlDeYYK9nU+kdX/91AC4lhkhINh5oF5NU8nyMdKwdLk+apGwyaFKkpyU
         sGfvTH+jTHFnH0u0gUO4S1Vof+H4xb+m0sr/CBD4y1naeXyACWnoZgji6+9Ih89KLB9G
         JcNw==
X-Gm-Message-State: APjAAAVyA2sZqUxbTZDgpM5O1Tma0lbVfzZVOPpqfuPTbbVf1TDflazE
        SdY/CV9Vfc9uAx08JjKrjc5RHuP0R4sNOHdJNQ==
X-Google-Smtp-Source: APXvYqzz4VrswngILkGa06/E+atrOe53GyPj1UlxE6LE24dDIzpzu/wCbWiFtgIY7KDHf9KpP9Wk4N/bheSdDSEjYaY=
X-Received: by 2002:a05:6638:2b7:: with SMTP id d23mr1598177jaq.108.1574953700274;
 Thu, 28 Nov 2019 07:08:20 -0800 (PST)
MIME-Version: 1.0
References: <20191128085409.289684-1-tz.stoyanov@gmail.com> <20191128085409.289684-17-tz.stoyanov@gmail.com>
In-Reply-To: <20191128085409.289684-17-tz.stoyanov@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Thu, 28 Nov 2019 17:08:08 +0200
Message-ID: <CAE0o1Nv33cEQGGX92XDCW7Y_E8CZ2uZ-ZKV=-_TkMeh3LB02DQ@mail.gmail.com>
Subject: Re: [PATCH v15 16/18] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 28, 2019 at 11:02 AM Tzvetomir Stoyanov (VMware)
<tz.stoyanov@gmail.com> wrote:

[...]

> --- a/Documentation/trace-cmd-record.1.txt
> +++ b/Documentation/trace-cmd-record.1.txt
> @@ -338,6 +338,12 @@ OPTIONS
>      the offset will also be in nanoseconds even if the displayed units are
>      in microseconds.
>
> +*--tsync-interval*::
> +    Set the loop interval, in ms, for timestamps synchronization with guests:
> +        If a negative number is specified, timestamps synchronization is disabled
> +        If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
> +        at the beginnig and at the end of the trace\n"

Typo in "beginnig".

[...]

> diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
> index a34297f..8944013 100644
> --- a/lib/trace-cmd/trace-msg.c
> +++ b/lib/trace-cmd/trace-msg.c
> @@ -26,8 +26,12 @@
>  #include "trace-local.h"
>  #include "trace-msg.h"
>
> +typedef __u16 u16;
> +typedef __s16 s16;

s16 and u16 seem to not be used.

[...]

> @@ -264,6 +278,17 @@ static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
>         return ret;
>  }
>
> +static int tracecmd_msg_send_nofree(int fd, struct tracecmd_msg *msg)
> +{
> +       int ret = 0;
> +
> +       ret = msg_write(fd, msg);
> +       if (ret < 0)
> +               ret = -ECOMM;
> +
> +       return ret;
> +}

Maybe reuse tracecmd_msg_send_nofree in tracecmd_msg_send above?

[...]

> +int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
> +                               unsigned int *sync_protocol,
> +                               unsigned int *sync_msg_id,
> +                               unsigned int *payload_size, char **payload)
> +{
> +       struct tracecmd_msg msg;
> +       int ret = -1;
> +       int buf_size;
> +
> +       memset(&msg, 0, sizeof(msg));
> +       ret = tracecmd_msg_recv(msg_handle->fd, &msg);
> +       if (ret < 0)
> +               goto out;
> +
> +       if (ntohl(msg.hdr.cmd) != MSG_TIME_SYNC) {
> +               ret = -EOPNOTSUPP;
> +               goto out;
> +       }
> +
> +       if (sync_protocol)
> +               *sync_protocol = ntohl(msg.tsync.sync_protocol);
> +       if (sync_msg_id)
> +               *sync_msg_id = ntohl(msg.tsync.sync_msg_id);
> +
> +       buf_size = msg_buf_len(&msg);
> +       if (buf_size < 0) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       if (buf_size && payload && payload_size) {
> +               if (*payload_size) {
> +                       if (*payload_size != buf_size || *payload == NULL) {
> +                               ret = -ENOMEM;

Returning ENOMEM in this case is confusing. If this case is intended
make it so that we don't allocate on each tracecmd_msg_recv_time_sync,
maybe do realloc() here instead?

-- 
Slavomir Kaslev
