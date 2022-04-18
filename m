Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A61C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Apr 2022 10:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiDRKZR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 06:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiDRKZQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 06:25:16 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3964919C16
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:22:38 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id t4so18122395pgc.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YAmmGpj51LH+T5qQ2qScMn09sLuxu93067dqnzy00bM=;
        b=YP1s0SNh45b2t91xXf3qx5Z57Qy6p0pK+zZ9RD+NVaZXs83taR8ozqDW8bwSwCX93O
         EPU8wZPwwMnMfIQjjyBKNQ6Qk1zQ+RgkhHcmw3QNedRPKz5MfKlksbdS3ZGISD1XcxLl
         rrX9XnxxjEqeEJMD0KysohZjxNZG+e/c6CuD+akmACnta3ELgSJ3CtYuJJSwN3+mAX+z
         aKv5Xt6ZdpeY6pRaVkFlsiKQbQMvE8c/cIRThRtY26pM993CgjiAsHci0lstEGck1EXv
         aobRuDUBCHjdjFPjz2ozYOayjJWSOeDphmVIF2NfXmSUARh/CP6c2ufJDixnGjEvfusp
         2d5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YAmmGpj51LH+T5qQ2qScMn09sLuxu93067dqnzy00bM=;
        b=6mGRwD0ywwOQdKsmqyT+cy7ReNMCVkacSWwZBNWEpTGTF2sIU8kW92ltmkjip0Eln0
         WFpCJ9rYYNwwyqJCYpENrQZF0r4MB0D+8o326EhgRj6jMgebBcYjIGBVkYPsPabGzWTx
         Yr3Gw4NqmCQ4rN+osaxNymEE3u5Tkbh+/9oYz1cxb2h1X3Z06WrTHbCEOd1NLHIIHWV0
         Gn9lZYlwXWEU9ySFoD29pQgVAzxqarlcPblPDIGbhiFzORAmxZQV3h++DyJgR07rmxnI
         9rqZ98vRVQhhUc4prcVDWISDF9/CgN+gmmr1wWfiBEOFk7MOhbIIf4TgSi0ZID/wwEDk
         X4iQ==
X-Gm-Message-State: AOAM533BoW6Qz1LJjrDhmiwUb6yD9y0/rH/AXFW2/Wqzi+CIoJj4VLNH
        JT/GUbiOu30pGNvuHeqveYC92wVOW8sNqgWUiJ53cb5H
X-Google-Smtp-Source: ABdhPJwfdRyT+EMth9XN3tQK97KoEcOOmjP87cve0RSqilq0TzEFjAL3+2BYhHPfHtGnpsrQ9vtBUzUjMYFiDktp4QM=
X-Received: by 2002:a63:1325:0:b0:39d:8eaa:27f7 with SMTP id
 i37-20020a631325000000b0039d8eaa27f7mr9597850pgl.297.1650277357650; Mon, 18
 Apr 2022 03:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220417184538.1044417-1-rostedt@goodmis.org> <20220417184538.1044417-2-rostedt@goodmis.org>
In-Reply-To: <20220417184538.1044417-2-rostedt@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 18 Apr 2022 13:22:21 +0300
Message-ID: <CAPpZLN6hbomCn5DUPvOKyVtzqWeoGjdT2OUc9XNBYNgekjRtdQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] trace-cmd record: Move port_type into instance
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 18, 2022 at 10:11 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> Instead of one global method of communication, have the "port_type" be
> part of the instance. This will allow for different instances to have
> different connection types.
>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  tracecmd/include/trace-local.h |  1 +
>  tracecmd/trace-record.c        | 41 ++++++++++++++++++----------------
>  2 files changed, 23 insertions(+), 19 deletions(-)
>
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index aa1cb8d939bd..2008449bab27 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -285,6 +285,7 @@ struct buffer_instance {
>         int                     *fds;
>         bool                    use_fifos;
>
> +       enum port_type          port_type;

I would suggest setting the default value of port_type explicitly in
allocate_instance(). Even though USE_UDP is 0, it is more clear. The
first time when I went through these changes, I was wondering why UDP
is not set at all. Then found that it was a static boolean in the
previous implementation, defaulting to false.


>         int                     tsync_loop_interval;
>         struct tracecmd_time_sync *tsync;
>  };
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 674ec2c3ba65..14ba4ac5dc9e 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -90,8 +90,6 @@ static bool fork_process;
>  /* Max size to let a per cpu file get */
>  static int max_kb;
>
> -static enum port_type port_type;
> -
>  static int do_ptrace;
>
>  static int filter_task;
> @@ -3119,7 +3117,7 @@ static void finish(int sig)
>         finished = 1;
>  }
>
> -static int connect_port(const char *host, unsigned int port)
> +static int connect_port(const char *host, unsigned int port, enum port_type type)
>  {
>         struct addrinfo hints;
>         struct addrinfo *results, *rp;
> @@ -3128,17 +3126,17 @@ static int connect_port(const char *host, unsigned int port)
>
>         snprintf(buf, BUFSIZ, "%u", port);
>
> -       if (port_type == USE_VSOCK)
> +       if (type == USE_VSOCK)
>                 return trace_vsock_open(atoi(host), port);
>
>         memset(&hints, 0, sizeof(hints));
>         hints.ai_family = AF_UNSPEC;
> -       hints.ai_socktype = port_type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
> +       hints.ai_socktype = type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
>
>         s = getaddrinfo(host, buf, &hints, &results);
>         if (s != 0)
>                 die("connecting to %s server %s:%s",
> -                   port_type == USE_TCP ? "TCP" : "UDP", host, buf);
> +                   type == USE_TCP ? "TCP" : "UDP", host, buf);
>
>         for (rp = results; rp != NULL; rp = rp->ai_next) {
>                 sfd = socket(rp->ai_family, rp->ai_socktype,
> @@ -3152,7 +3150,7 @@ static int connect_port(const char *host, unsigned int port)
>
>         if (rp == NULL)
>                 die("Can not connect to %s server %s:%s",
> -                   port_type == USE_TCP ? "TCP" : "UDP", host, buf);
> +                   type == USE_TCP ? "TCP" : "UDP", host, buf);
>
>         freeaddrinfo(results);
>
> @@ -3359,7 +3357,8 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
>                         else
>                                 fd = do_accept(instance->fds[cpu]);
>                 } else {
> -                       fd = connect_port(host, instance->client_ports[cpu]);
> +                       fd = connect_port(host, instance->client_ports[cpu],
> +                                         instance->port_type);
>                 }
>                 if (fd < 0)
>                         die("Failed connecting to client");
> @@ -3414,8 +3413,9 @@ static void check_first_msg_from_server(struct tracecmd_msg_handle *msg_handle)
>  }
>
>  static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
> -                                        unsigned int **client_ports)
> +                                        struct buffer_instance *instance)
>  {
> +       unsigned int *client_ports;
>         char buf[BUFSIZ];
>         ssize_t n;
>         int cpu, i;
> @@ -3442,11 +3442,11 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
>         /* TODO, test for ipv4 */
>         if (page_size >= UDP_MAX_PACKET) {
>                 warning("page size too big for UDP using TCP in live read");
> -               port_type = USE_TCP;
> +               instance->port_type = USE_TCP;
>                 msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
>         }
>
> -       if (port_type == USE_TCP) {
> +       if (instance->port_type == USE_TCP) {
>                 /* Send one option */
>                 write(msg_handle->fd, "1", 2);
>                 /* Size 4 */
> @@ -3457,8 +3457,8 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
>                 /* No options */
>                 write(msg_handle->fd, "0", 2);
>
> -       *client_ports = malloc(local_cpu_count * sizeof(*client_ports));
> -       if (!*client_ports)
> +       client_ports = malloc(local_cpu_count * sizeof(*client_ports));
> +       if (!client_ports)
>                 die("Failed to allocate client ports for %d cpus", local_cpu_count);
>
>         /*
> @@ -3476,8 +3476,10 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle,
>                 if (i == BUFSIZ)
>                         die("read bad port number");
>                 buf[i] = 0;
> -               (*client_ports)[cpu] = atoi(buf);
> +               client_ports[cpu] = atoi(buf);
>         }
> +
> +       instance->client_ports = client_ports;
>  }
>
>  static void communicate_with_listener_v3(struct tracecmd_msg_handle *msg_handle,
> @@ -3609,10 +3611,11 @@ static int connect_ip(char *thost)
>  static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance)
>  {
>         struct tracecmd_msg_handle *msg_handle = NULL;
> +       enum port_type type = instance->port_type;
>         int sfd;
>
>  again:
> -       switch (port_type) {
> +       switch (type) {
>         case USE_VSOCK:
>                 sfd = connect_vsock(host);
>                 break;
> @@ -3634,7 +3637,7 @@ again:
>                 msg_handle->version = V3_PROTOCOL;
>         }
>
> -       switch (port_type) {
> +       switch (type) {
>         case USE_TCP:
>                 msg_handle->flags |= TRACECMD_MSG_FL_USE_TCP;
>                 break;
> @@ -3657,7 +3660,7 @@ again:
>         }
>
>         if (msg_handle->version == V1_PROTOCOL)
> -               communicate_with_listener_v1(msg_handle, &instance->client_ports);
> +               communicate_with_listener_v1(msg_handle, instance);
>
>         return msg_handle;
>  }
> @@ -6514,7 +6517,7 @@ static void parse_record_options(int argc,
>                         if (ctx->output)
>                                 die("-V incompatible with -o");
>                         host = optarg;
> -                       port_type = USE_VSOCK;
> +                       ctx->instance->port_type = USE_VSOCK;
>                         break;
>                 case 'm':
>                         if (max_kb)
> @@ -6532,7 +6535,7 @@ static void parse_record_options(int argc,
>                         if (IS_EXTRACT(ctx))
>                                 ctx->topt = 1; /* Extract top instance also */
>                         else
> -                               port_type = USE_TCP;
> +                               ctx->instance->port_type = USE_TCP;
>                         break;
>                 case 'b':
>                         check_instance_die(ctx->instance, "-b");
> --
> 2.35.1
>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
