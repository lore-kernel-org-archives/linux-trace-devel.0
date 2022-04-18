Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B94AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Apr 2022 10:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbiDRKZr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 06:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbiDRKZr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 06:25:47 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23FDA1BC
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:23:07 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t12so11993333pll.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H3kYn1MB4iZTnnLM0f7crGSIEgeDkoz+00Slm2SArvs=;
        b=DmsSQBVcw83OfvWxHs1UD8zECmW8oNkfkIPr1d1ae97mPKu+UXZSQs9iTSmVcn6cSu
         qkF8edhzZ9OwlNzZu0qwi0y5Or+PndYyzcHOVBRm1IbEUAiCQPBZhClrA7tw824L05Ty
         PNYCwX/CsDa4zJvsY1oatyFi/Uq5vjzqNbbXSnL6Kyp+NRkENXiJ3HJSEYme2pLmJgNu
         UG2m6yWOOUBwrAMpupRq6IJXSdIQpY6+6+j+teoUxyCSdxwMjESQqlzxiW4IaM1X8nzo
         0h0W14XCwvXzZ+J++LodKKjxLRz9c7T2G6NSWex36kt0d4XTC1ZzV+NphSJMfiE3Fzmu
         QZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H3kYn1MB4iZTnnLM0f7crGSIEgeDkoz+00Slm2SArvs=;
        b=0bAFvmyGSMseLEky5rn4ozk48S4oEgexAbPVSlX10tOBpN+BBMGMekb1Oz2DcQnx8x
         k7ldP3sadp7h3pgBd0eT8ZukRHmZorJxdeSHa6EBtADa13pXVaxZZy0EAzCEOqLKIS01
         VwuPy/6fsrbI0ZTsY35c0qc3bOKDdZbi/rcC3wVS/BENQ19rrRCvOCYPwM2omgIBLIko
         HvTL9CS3GLb61R9N/PpAkwTsZNLb14wlHob0rYKMzI3AzXMLqWtJckOzU3hDeeMUxXfp
         hJS5mFLnCA7Esxyuuuu5mGuZQKR4sDOsm+p4MKVW3yjMhwy6xeDPand/qcGueNNs428f
         fdCA==
X-Gm-Message-State: AOAM530HWrna+Aod5tCBKNdGq2M/q5BiAF0e4BLBzBk75gj1G6DqkvAc
        K7yHLadiPwvnVlyjMik86oMJ68tmQi9MeOLcwJQsvsSA
X-Google-Smtp-Source: ABdhPJyP5hZ5b54Foh1Vg7YY1hAOOJF1HdeuJREkOedQtsgS5jVGjA7HbJTRuImOlszet4kfFI6UZrJ6wPyj/y47EL0=
X-Received: by 2002:a17:90a:384d:b0:1d2:97de:eb8c with SMTP id
 l13-20020a17090a384d00b001d297deeb8cmr4793454pjf.208.1650277387308; Mon, 18
 Apr 2022 03:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220417184538.1044417-1-rostedt@goodmis.org> <20220417184538.1044417-5-rostedt@goodmis.org>
In-Reply-To: <20220417184538.1044417-5-rostedt@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 18 Apr 2022 13:22:51 +0300
Message-ID: <CAPpZLN6UyZ00koS+FWWsq_SKYpoYMkSb_TTNmehG2LwBu3P6OA@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] trace-cmd agent: Allow for ip connections from the agent
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 18, 2022 at 11:28 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> Add a -N option to trace-cmd agent to listen on a network socket that
> can be used by trace-cmd record -A to connect with.
>

I have concerns about exposing the agent over the network, without any
client authentication. It runs with root privileges, the kernel
tracing data will be exposed to anyone over the network. At least,
this should be written clearly in the documentation and even should be
printed by "trace-cmd agent -N ...". I saw your patch that adds a name
or IP address of the client as parameter, it is some security, but the
tracing data itself still flows unencrypted over the network and could
be visible to anyone.


> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  tracecmd/include/trace-local.h |  6 +++
>  tracecmd/trace-agent.c         | 89 ++++++++++++++++++++++++++--------
>  tracecmd/trace-listen.c        | 58 ++++++++++++++--------
>  3 files changed, 113 insertions(+), 40 deletions(-)
>
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index afbcab422c2f..fdb0d887557f 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -306,6 +306,12 @@ extern struct buffer_instance *first_instance;
>  #define is_guest(instance)     ((instance)->flags & BUFFER_FL_GUEST)
>  #define is_network(instance)   ((instance)->flags & BUFFER_FL_NETWORK)
>
> +#define START_PORT_SEARCH 1500
> +#define MAX_PORT_SEARCH 6000
> +
> +int trace_net_make(int port, enum port_type type);
> +int trace_net_search(int start_port, int *sfd, enum port_type type);
> +
>  struct buffer_instance *allocate_instance(const char *name);
>  void add_instance(struct buffer_instance *instance, int cpu_count);
>  void update_first_instance(struct buffer_instance *instance, int topt);
> diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
> index 719d7126ca67..cd201ad948ad 100644
> --- a/tracecmd/trace-agent.c
> +++ b/tracecmd/trace-agent.c
> @@ -41,6 +41,32 @@ static void make_vsocks(int nr, int *fds, unsigned int *ports)
>         }
>  }
>
> +static void make_net(int nr, int *fds, unsigned int *ports)
> +{
> +       int port;
> +       int i, fd;
> +       int start_port = START_PORT_SEARCH;
> +
> +       for (i = 0; i < nr; i++) {
> +               port = trace_net_search(start_port, &fd, USE_TCP);
> +               if (port < 0)
> +                       die("Failed to open socket");
> +               if (listen(fd, 5) < 0)
> +                       die("Failed to listen on port %d\n", port);
> +               fds[i] = fd;
> +               ports[i] = port;
> +               start_port = port + 1;
> +       }
> +}
> +
> +static void make_sockets(int nr, int *fds, unsigned int *ports, bool network)
> +{
> +       if (network)
> +               return make_net(nr, fds, ports);
> +       else
> +               return make_vsocks(nr, fds, ports);
> +}
> +
>  static int open_agent_fifos(int nr_cpus, int *fds)
>  {
>         char path[PATH_MAX];
> @@ -80,7 +106,7 @@ static char *get_clock(int argc, char **argv)
>         return NULL;
>  }
>
> -static void agent_handle(int sd, int nr_cpus, int page_size)
> +static void agent_handle(int sd, int nr_cpus, int page_size, bool network)
>  {
>         struct tracecmd_tsync_protos *tsync_protos = NULL;
>         struct tracecmd_time_sync *tsync = NULL;
> @@ -117,17 +143,31 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
>                 use_fifos = false;
>
>         if (!use_fifos)
> -               make_vsocks(nr_cpus, fds, ports);
> +               make_sockets(nr_cpus, fds, ports, network);
>         if (tsync_protos && tsync_protos->names) {
> -               if (get_vsocket_params(msg_handle->fd, &local_id,
> -                                      &remote_id)) {
> -                       warning("Failed to get local and remote ids");
> -                       /* Just make something up */
> -                       remote_id = -1;
> -                       local_id = -2;
> +               if (network) {
> +                       /* For now just use something */
> +                       remote_id = 2;
> +                       local_id = 1;
> +                       tsync_port = trace_net_search(START_PORT_SEARCH, &fd, USE_TCP);
> +                       if (listen(fd, 5) < 0)
> +                               die("Failed to listen on %d\n", tsync_port);
> +               } else {
> +                       if (get_vsocket_params(msg_handle->fd, &local_id,
> +                                              &remote_id)) {
> +                               warning("Failed to get local and remote ids");
> +                               /* Just make something up */
> +                               remote_id = -1;
> +                               local_id = -2;
> +                       }
> +                       fd = trace_vsock_make_any();
> +                       if (fd >= 0 &&
> +                           trace_vsock_get_port(fd, &tsync_port) < 0) {
> +                               close(fd);
> +                               fd = -1;
> +                       }
>                 }
> -               fd = trace_vsock_make_any();
> -               if (fd >= 0 && trace_vsock_get_port(fd, &tsync_port) >= 0) {
> +               if (fd >= 0) {
>                         tsync = tracecmd_tsync_with_host(fd, tsync_protos,
>                                                          get_clock(argc, argv),
>                                                          remote_id, local_id);
> @@ -193,7 +233,7 @@ static pid_t do_fork()
>         return fork();
>  }
>
> -static void agent_serve(unsigned int port, bool do_daemon)
> +static void agent_serve(unsigned int port, bool do_daemon, bool network)
>  {
>         int sd, cd, nr_cpus;
>         unsigned int cid;
> @@ -204,14 +244,21 @@ static void agent_serve(unsigned int port, bool do_daemon)
>         nr_cpus = tracecmd_count_cpus();
>         page_size = getpagesize();
>
> -       sd = trace_vsock_make(port);
> +       if (network) {
> +               sd = trace_net_make(port, USE_TCP);
> +               if (listen(sd, 5) < 0)
> +                       die("Failed to listen on %d\n", port);
> +       } else
> +               sd = trace_vsock_make(port);
>         if (sd < 0)
> -               die("Failed to open vsocket");
> +               die("Failed to open socket");
>         tracecmd_tsync_init();
>
> -       cid = trace_vsock_local_cid();
> -       if (cid >= 0)
> -               printf("listening on @%u:%u\n", cid, port);
> +       if (!network) {
> +               cid = trace_vsock_local_cid();
> +               if (cid >= 0)
> +                       printf("listening on @%u:%u\n", cid, port);
> +       }
>
>         if (do_daemon && daemon(1, 0))
>                 die("daemon");
> @@ -231,7 +278,7 @@ static void agent_serve(unsigned int port, bool do_daemon)
>                 if (pid == 0) {
>                         close(sd);
>                         signal(SIGCHLD, SIG_DFL);
> -                       agent_handle(cd, nr_cpus, page_size);
> +                       agent_handle(cd, nr_cpus, page_size, network);
>                 }
>                 if (pid > 0)
>                         handler_pid = pid;
> @@ -250,6 +297,7 @@ void trace_agent(int argc, char **argv)
>  {
>         bool do_daemon = false;
>         unsigned int port = TRACE_AGENT_DEFAULT_PORT;
> +       bool network = false;
>
>         if (argc < 2)
>                 usage(argv);
> @@ -267,7 +315,7 @@ void trace_agent(int argc, char **argv)
>                         {NULL, 0, NULL, 0}
>                 };
>
> -               c = getopt_long(argc-1, argv+1, "+hp:D",
> +               c = getopt_long(argc-1, argv+1, "+hp:DN",
>                                 long_options, &option_index);
>                 if (c == -1)
>                         break;
> @@ -275,6 +323,9 @@ void trace_agent(int argc, char **argv)
>                 case 'h':
>                         usage(argv);
>                         break;
> +               case 'N':
> +                       network = true;
> +                       break;
>                 case 'p':
>                         port = atoi(optarg);
>                         break;
> @@ -296,5 +347,5 @@ void trace_agent(int argc, char **argv)
>         if (optind < argc-1)
>                 usage(argv);
>
> -       agent_serve(port, do_daemon);
> +       agent_serve(port, do_daemon, network);
>  }
> diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
> index 2338173fc8a6..8476fa51dadd 100644
> --- a/tracecmd/trace-listen.c
> +++ b/tracecmd/trace-listen.c
> @@ -234,52 +234,68 @@ static int setup_vsock_port(int start_port, int *sfd)
>         return start_port;
>  }
>
> -#define START_PORT_SEARCH 1500
> -#define MAX_PORT_SEARCH 6000
> -
> -static int bind_a_port(int start_port, int *sfd, enum port_type type)
> +int trace_net_make(int port, enum port_type type)
>  {
>         struct addrinfo hints;
>         struct addrinfo *result, *rp;
>         char buf[BUFSIZ];
> +       int sd;
>         int s;
> -       int num_port = start_port;
>
> -       if (type == USE_VSOCK)
> -               return setup_vsock_port(start_port, sfd);
> - again:
> -       snprintf(buf, BUFSIZ, "%d", num_port);
> +       snprintf(buf, BUFSIZ, "%d", port);
>
>         memset(&hints, 0, sizeof(hints));
>         hints.ai_family = AF_UNSPEC;
> -       hints.ai_socktype = type == USE_TCP ? SOCK_STREAM : SOCK_DGRAM;
>         hints.ai_flags = AI_PASSIVE;
>
> +       switch (type) {
> +       case USE_TCP:
> +               hints.ai_socktype = SOCK_STREAM;
> +               break;
> +       case USE_UDP:
> +               hints.ai_socktype = SOCK_DGRAM;
> +               break;
> +       default:
> +               return -1;
> +       }
> +
>         s = getaddrinfo(NULL, buf, &hints, &result);
>         if (s != 0)
>                 pdie("getaddrinfo: error opening socket");
>
>         for (rp = result; rp != NULL; rp = rp->ai_next) {
> -               *sfd = socket(rp->ai_family, rp->ai_socktype,
> -                             rp->ai_protocol);
> -               if (*sfd < 0)
> +               sd = socket(rp->ai_family, rp->ai_socktype,
> +                           rp->ai_protocol);
> +               if (sd < 0)
>                         continue;
>
> -               if (bind(*sfd, rp->ai_addr, rp->ai_addrlen) == 0)
> +               if (bind(sd, rp->ai_addr, rp->ai_addrlen) == 0)
>                         break;
>
> -               close(*sfd);
> +               close(sd);
>         }
> +       freeaddrinfo(result);
> +
> +       if (rp == NULL)
> +               return -1;
> +
> +       return sd;
> +}
> +
> +int trace_net_search(int start_port, int *sfd, enum port_type type)
> +{
> +       int num_port = start_port;
>
> -       if (rp == NULL) {
> -               freeaddrinfo(result);
> +       if (type == USE_VSOCK)
> +               return setup_vsock_port(start_port, sfd);
> + again:
> +       *sfd = trace_net_make(num_port, type);
> +       if (*sfd < 0) {
>                 if (++num_port > MAX_PORT_SEARCH)
>                         pdie("No available ports to bind");
>                 goto again;
>         }
>
> -       freeaddrinfo(result);
> -
>         return num_port;
>  }
>
> @@ -309,10 +325,10 @@ static int open_port(const char *node, const char *port, int *pid,
>         int num_port;
>
>         /*
> -        * bind_a_port() currently does not return an error, but if that
> +        * trace_net_search() currently does not return an error, but if that
>          * changes in the future, we have a check for it now.
>          */
> -       num_port = bind_a_port(start_port, &sfd, type);
> +       num_port = trace_net_search(start_port, &sfd, type);
>         if (num_port < 0)
>                 return num_port;
>
> --
> 2.35.1
>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
