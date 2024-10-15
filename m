Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB1F20311
	for <linux-trace-devel@vger.kernel.org>; Tue, 15 Oct 2024 13:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729000056; cv=none; b=SdNwC2Q3eReJ2sJWNblaTMahtKJSJRgREu3qtbTC2rhtOip2twyNB2PTEJmuZGYL5JI150nhjPKtd0TBS3eIpIW5gudF7rnj79WK+u3LCZbb5u1Ke4TSugkCluIoc3CDxNzXfyJZchNMldfKwcVB2kXPTGHzNsIYEqRO+xc7dd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729000056; c=relaxed/simple;
	bh=x7gWwA15PkX0swkohFn7dc74VELejjCg5QVQ1pdnFpE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eK5SqORS82sZ350P9AXkM4nDn0RynY3o746ExTgsxRlxz9P2AOithszQUIFd/u3qmcyyvL4B6KsN7wZoJhXBOQeN2M+91orjUf38ArXxZcLchI4W73Px8m3RA/05U9LXaqPZr4ZJxBTzNCcsWG9lSQtPzi2J+vNPPOX6Apvy/9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175CCC4CEC6;
	Tue, 15 Oct 2024 13:47:35 +0000 (UTC)
Date: Tue, 15 Oct 2024 09:47:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] trace-cmd reset: Add option to preserve specific
 events
Message-ID: <20241015094754.1ec1825a@gandalf.local.home>
In-Reply-To: <d46e317c-075a-4c08-a6c8-db236130c35a@arm.com>
References: <20241014123136.3890807-1-metin.kaya@arm.com>
	<20241014175905.03bec85a@gandalf.local.home>
	<d46e317c-075a-4c08-a6c8-db236130c35a@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Oct 2024 14:30:58 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

> On 14/10/2024 10:59 pm, Steven Rostedt wrote:
> > On Mon, 14 Oct 2024 13:31:32 +0100
> > Metin Kaya <metin.kaya@arm.com> wrote:
> >  
> >> Changes since v1:
> >> - Update man page for -k command line parameter of "trace-cmd reset".
> >> - Add tab completion support for "trace-cmd reset".  
> >
> > Thanks, I'll go ahead and apply this. But can you do me a favor, and add a
> > test case to utest/tracecmd-utest.c that tests this. It should create a
> > each of the types, start tracing, do the reset, and make sure that the -k
> > keeps what is expected. Doesn't need to be too fancy.  
> 
> I wrote the patch below, but noticed I'm unable to preserve uprobes
> during reset. I verified trace-cmd tries to prevent
> TRACEFS_DYNEVENT_UPROBE from being destroyed, but I cannot see them
> after running "trace-cmd reset -k uprobe" command.
> The same problem exists for uretprobe, too.
> I confirmed utest uses correct trace-cmd executable.
> 
> Any ideas?

I'll check it out, but your patch below is all messed up. Can you send it
properly?

Thanks,

-- Steve


> 
> -->8--  
> 
> commit 01d0822dc5e22a34155b0a70d56c67fa023ccacc
> Author: Metin Kaya <metin.kaya@arm.com>
> Date:   Tue Oct 15 09:34:49 2024 +0100
> 
>      trace-cmd utest: Add test cases for trace-cmd reset
> 
>      Implement test cases for dynamic event types kprobe, kretprobe, uprobe,
>      uretprobe and eprobe.
> 
>      Verify resetting synthetic events by inserting a hook to
>      test_trace_sqlhist_hist().
> 
>      While we are in the neighborhood, fix typo "ceated".
> 
>      Link:
> https://lore.kernel.org/linux-trace-devel/20241014175905.03bec85a@gandalf.local.home
> 
>      Signed-off-by: Metin Kaya <metin.kaya@arm.com>
> 
> diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
> index 164f5da1..c1a12965 100644
> --- a/utest/tracecmd-utest.c
> +++ b/utest/tracecmd-utest.c
> @@ -352,6 +352,11 @@ static void test_trace_sqlhist_hist(void)
>         sleep(1);
>         ret = grep_match(SYNTH_EVENT ":", "show", NULL);
>         CU_TEST(ret == 0);
> +       /* Ensure synthetic events remain untouched after "trace-cmd reset -k
> synth". */
> +       ret = run_trace("reset", "-k", "synth", NULL);
> +       CU_TEST(ret == 0);
> +       ret = grep_match(SYNTH_EVENT, "stat", NULL);
> +       CU_TEST(ret == 0);
> 
>         tracefs_instance_reset(NULL);
>   }
> @@ -598,6 +603,159 @@ static void test_trace_library_read_back(void)
>         tracecmd_close(handle);
>   }
> 
> +static void test_trace_reset_kprobe(void)
> +{
> +       int ret;
> +       FILE *fp;
> +
> +       /* Create a simple kprobe for do_sys_open */
> +       fp = fopen("/sys/kernel/tracing/kprobe_events", "w");
> +       CU_TEST(fp != NULL);
> +       fprintf(fp, "p do_sys_open");
> +       fclose(fp);
> +
> +       /* Ensure the kprobe is listed in "trace-cmd stat" output. */
> +       ret = grep_match("p:kprobes/p_do_sys_open_0 do_sys_open", "stat", NULL);
> +       CU_TEST(ret == 0);
> +
> +       /* Issue "trace-cmd reset", but keep kprobes. */
> +       ret = run_trace("reset", "-k", "kprobe", NULL);
> +       CU_TEST(ret == 0);
> +
> +       /* Verify the kprobe's existence after reset. */
> +       ret = grep_match("p:kprobes/p_do_sys_open_0 do_sys_open", "stat", NULL);
> +       CU_TEST(ret == 0);
> +}
> +
> +static void test_trace_reset_kretprobe(void)
> +{
> +       int ret;
> +       FILE *fp;
> +
> +       /* Create a simple kretprobe for do_sys_open */
> +       fp = fopen("/sys/kernel/tracing/kprobe_events", "w");
> +       CU_TEST(fp != NULL);
> +       fprintf(fp, "r do_sys_open");
> +       fclose(fp);
> +
> +       /* Ensure the kretprobe is listed in "trace-cmd stat" output. */
> +       ret = grep_match("r128:kprobes/r_do_sys_open_0 do_sys_open", "stat",
> NULL);
> +       CU_TEST(ret == 0);
> +
> +       /* Issue "trace-cmd reset", but keep kretprobes. */
> +       ret = run_trace("reset", "-k", "kretprobe", NULL);
> +       CU_TEST(ret == 0);
> +
> +       /* Verify the kretprobe's existence after reset. */
> +       ret = grep_match("r128:kprobes/r_do_sys_open_0 do_sys_open", "stat",
> NULL);
> +       CU_TEST(ret == 0);
> +}
> +
> +static void test_trace_reset_uprobe(void)
> +{
> +       int ret;
> +       FILE *fp;
> +
> +       /* Create a simple uprobe for do_sys_open */
> +       fp = fopen("/sys/kernel/tracing/uprobe_events", "w");
> +       CU_TEST(fp != NULL);
> +       fprintf(fp, "p /bin/bash:0x4245c0");
> +       fclose(fp);
> +
> +       /* Ensure the uprobe is listed in "trace-cmd stat" output. */
> +       ret = grep_match("p:uprobes/p_bash_0x4245c0
> /bin/bash:0x00000000004245c0", "stat", NULL);
> +       CU_TEST(ret == 0);
> +
> +       /* Issue "trace-cmd reset", but keep uprobes. */
> +       ret = run_trace("reset", "-k", "uprobe", NULL);
> +       CU_TEST(ret == 0);
> +
> +       /* Verify the uprobe's existence after reset. */
> +       ret = grep_match("p:uprobes/p_bash_0x4245c0
> /bin/bash:0x00000000004245c0", "stat", NULL);
> +       CU_TEST(ret == 0); // TODO: FAILS!
> +}
> +
> +static void test_trace_reset_uretprobe(void)
> +{
> +       int ret;
> +       FILE *fp;
> +
> +       /* Create a simple uretprobe for do_sys_open */
> +       fp = fopen("/sys/kernel/tracing/uprobe_events", "w");
> +       CU_TEST(fp != NULL);
> +       fprintf(fp, "r /bin/bash:0x4245c0");
> +       fclose(fp);
> +
> +       /* Ensure the uretprobe is listed in "trace-cmd stat" output. */
> +       ret = grep_match("r:uprobes/p_bash_0x4245c0
> /bin/bash:0x00000000004245c0", "stat", NULL);
> +       CU_TEST(ret == 0);
> +
> +       /* Issue "trace-cmd reset", but keep uretprobes. */
> +       ret = run_trace("reset", "-k", "uretprobe", NULL);
> +       CU_TEST(ret == 0);
> +
> +       /* Verify the uretprobe's existence after reset. */
> +       ret = grep_match("r:uprobes/p_bash_0x4245c0
> /bin/bash:0x00000000004245c0", "stat", NULL);
> +       CU_TEST(ret == 0); // TODO: FAILS!
> +}
> +
> +static void test_trace_reset_eprobe(void)
> +{
> +       int ret;
> +       bool matched = false;
> +       size_t l = 0;
> +       ssize_t n;
> +       char *buf = NULL;
> +       struct tracefs_dynevent *deprobe;
> +       FILE *fp;
> +
> +       deprobe = tracefs_eprobe_alloc(NULL, "sopen_in", "syscalls",
> "sys_enter_openat", NULL);
> +       CU_TEST(deprobe != NULL);
> +
> +       ret = tracefs_dynevent_create(deprobe);
> +       CU_TEST(ret == 0);
> +
> +       /* Issue "trace-cmd reset", but keep eprobes. */
> +       ret = run_trace("reset", "-k", "eprobe", NULL);
> +       CU_TEST(ret == 0);
> +
> +       /* Verify the eprobe's existence after reset. */
> +       fp = fopen("/sys/kernel/tracing/dynamic_events", "r");
> +       CU_TEST(fp != NULL);
> +
> +       while ((n = getline(&buf, &l, fp)) != -1) {
> +               if (!strcmp(buf, "e:eprobes/sopen_in syscalls.sys_enter_openat\n")) {
> +                       matched = true;
> +                       break;
> +               }
> +       }
> +       free(buf);
> +
> +       fclose(fp);
> +
> +       CU_TEST(matched == true);
> +
> +       ret = tracefs_dynevent_destroy(deprobe, false);
> +       CU_TEST(ret == 0);
> +
> +       tracefs_dynevent_free(deprobe);
> +}
> +
> +static void test_trace_reset(void)
> +{
> +       int ret;
> +
> +       test_trace_reset_kprobe();
> +       test_trace_reset_kretprobe();
> +       test_trace_reset_uprobe();
> +       test_trace_reset_uretprobe();
> +       test_trace_reset_eprobe();
> +
> +       /* Destroy all dynamic events. */
> +       ret = run_trace("reset", NULL);
> +       CU_TEST(ret == 0);
> +}
> +
>   static int test_suite_destroy(void)
>   {
>         unlink(TRACECMD_FILE);
> @@ -639,7 +797,7 @@ void test_tracecmd_lib(void)
> 
>         suite = CU_add_suite(TRACECMD_SUITE, test_suite_init,
> test_suite_destroy);
>         if (suite == NULL) {
> -               fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACECMD_SUITE);
> +               fprintf(stderr, "Suite \"%s\" cannot be created\n", TRACECMD_SUITE);
>                 return;
>         }
>         CU_add_test(suite, "Simple record and report",
> @@ -656,4 +814,5 @@ void test_tracecmd_lib(void)
>                     test_trace_library_read_back);
>         CU_add_test(suite, "Test max length",
>                     test_trace_record_max);
> +       CU_add_test(suite, "Simple reset", test_trace_reset);
>   }
> 
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.

