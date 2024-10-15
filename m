Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AE41F669E
	for <linux-trace-devel@vger.kernel.org>; Tue, 15 Oct 2024 16:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010293; cv=none; b=d9do07r2ang5e0PZfttiZur1E+PykSJuhfJWIkdYrFQiDv+9jrtTNPoHiAPBZAOIiv2IRnFEEKcmB/PCKM/qVp7OVuN5zE4nEt2jBGBvHj0ibr3q6bYoyNovr5pUjkWkvQJzx+xpv2QRzL/z6pfSJ5KrHmXCDyogGFJ39eRL4QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010293; c=relaxed/simple;
	bh=Mazwxks4f5+NJ6fAc1COkew1/FcgjXpxLgcA6I/v0Zg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oLrrHzKH08QjGqWgrTg43AD/qNq8/2sKPSg3NDRPkJaCpCMWmAHBS6qtRZKXX73toSg+jWJOWkZqbUc61TznYNlLBpRpO+pnZKSZ+I+s+ITPTpqjPcYLQF0may47/i16wGs9Eht4YkEnY5txoraDqSA9kDqXX9x1w4++rsTGNIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0447C4CEC6;
	Tue, 15 Oct 2024 16:38:12 +0000 (UTC)
Date: Tue, 15 Oct 2024 12:38:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd utest: Add test cases for trace-cmd reset
Message-ID: <20241015123831.347ff0f4@gandalf.local.home>
In-Reply-To: <20241015140840.4183007-1-metin.kaya@arm.com>
References: <20241015140840.4183007-1-metin.kaya@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Oct 2024 15:08:40 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

> Implement test cases to confirm existing dynamic event types (kprobe,
> kretprobe, uprobe, uretprobe and eprobe) are really preserved during
> "trace-cmd reset".
> 
> Verify synthetic events by inserting a hook to
> test_trace_sqlhist_hist().
> 
> While we are in the neighborhood, fix typo "ceated".
> 
> TODO: I'm unable to prevent uprobes/uretprobes from being destroyed
> during reset.

That's not a bug with this code. It's a bug with libtracefs. I'll fix it.

> 
> Link: https://lore.kernel.org/linux-trace-devel/20241014175905.03bec85a@gandalf.local.home
> 
> Signed-off-by: Metin Kaya <metin.kaya@arm.com>
> ---
>  utest/tracecmd-utest.c | 161 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 160 insertions(+), 1 deletion(-)
> 
> diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
> index 164f5da1..b2f6b65b 100644
> --- a/utest/tracecmd-utest.c
> +++ b/utest/tracecmd-utest.c
> @@ -352,6 +352,11 @@ static void test_trace_sqlhist_hist(void)
>  	sleep(1);
>  	ret = grep_match(SYNTH_EVENT ":", "show", NULL);
>  	CU_TEST(ret == 0);
> +	/* Ensure synthetic events remain untouched after "trace-cmd reset -k synth". */
> +	ret = run_trace("reset", "-k", "synth", NULL);
> +	CU_TEST(ret == 0);
> +	ret = grep_match(SYNTH_EVENT, "stat", NULL);
> +	CU_TEST(ret == 0);
>  
>  	tracefs_instance_reset(NULL);
>  }
> @@ -598,6 +603,159 @@ static void test_trace_library_read_back(void)
>  	tracecmd_close(handle);
>  }
>  
> +static void test_trace_reset_kprobe(void)
> +{
> +	int ret;
> +	FILE *fp;
> +
> +	/* Create a simple kprobe for do_sys_open */
> +	fp = fopen("/sys/kernel/tracing/kprobe_events", "w");
> +	CU_TEST(fp != NULL);
> +	fprintf(fp, "p do_sys_open");
> +	fclose(fp);

This is open coded of:

	ret = tracefs_instance_file_write(NULL, "kprobe_events", "p do_sys_open");
	CU_TEST(ret > 0);

And there's no guarantee that tracefs will be mounted at
/sys/kernel/tracing, so the above is incorrect anyway.

> +
> +	/* Ensure the kprobe is listed in "trace-cmd stat" output. */
> +	ret = grep_match("p:kprobes/p_do_sys_open_0 do_sys_open", "stat", NULL);
> +	CU_TEST(ret == 0);
> +
> +	/* Issue "trace-cmd reset", but keep kprobes. */
> +	ret = run_trace("reset", "-k", "kprobe", NULL);
> +	CU_TEST(ret == 0);
> +
> +	/* Verify the kprobe's existence after reset. */
> +	ret = grep_match("p:kprobes/p_do_sys_open_0 do_sys_open", "stat", NULL);
> +	CU_TEST(ret == 0);
> +}
> +
> +static void test_trace_reset_kretprobe(void)
> +{
> +	int ret;
> +	FILE *fp;
> +
> +	/* Create a simple kretprobe for do_sys_open */
> +	fp = fopen("/sys/kernel/tracing/kprobe_events", "w");
> +	CU_TEST(fp != NULL);
> +	fprintf(fp, "r do_sys_open");
> +	fclose(fp);

Use tracefs_instance_file_write() here too.

> +
> +	/* Ensure the kretprobe is listed in "trace-cmd stat" output. */
> +	ret = grep_match("r128:kprobes/r_do_sys_open_0 do_sys_open", "stat", NULL);

Note, this failed for me, because mine had "r16:kprobes..."

> +	CU_TEST(ret == 0);
> +
> +	/* Issue "trace-cmd reset", but keep kretprobes. */
> +	ret = run_trace("reset", "-k", "kretprobe", NULL);
> +	CU_TEST(ret == 0);
> +
> +	/* Verify the kretprobe's existence after reset. */
> +	ret = grep_match("r128:kprobes/r_do_sys_open_0 do_sys_open", "stat", NULL);
> +	CU_TEST(ret == 0);
> +}
> +
> +static void test_trace_reset_uprobe(void)
> +{
> +	int ret;
> +	FILE *fp;
> +
> +	/* Create a simple uprobe for do_sys_open */
> +	fp = fopen("/sys/kernel/tracing/uprobe_events", "w");
> +	CU_TEST(fp != NULL);
> +	fprintf(fp, "p /bin/bash:0x4245c0");
> +	fclose(fp);

Ditto.

> +
> +	/* Ensure the uprobe is listed in "trace-cmd stat" output. */
> +	ret = grep_match("p:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0", "stat", NULL);
> +	CU_TEST(ret == 0);
> +
> +	/* Issue "trace-cmd reset", but keep uprobes. */
> +	ret = run_trace("reset", "-k", "uprobe", NULL);
> +	CU_TEST(ret == 0);
> +
> +	/* Verify the uprobe's existence after reset. */
> +	ret = grep_match("p:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0", "stat", NULL);
> +	CU_TEST(ret == 0);
> +}
> +
> +static void test_trace_reset_uretprobe(void)
> +{
> +	int ret;
> +	FILE *fp;
> +
> +	/* Create a simple uretprobe for do_sys_open */
> +	fp = fopen("/sys/kernel/tracing/uprobe_events", "w");
> +	CU_TEST(fp != NULL);
> +	fprintf(fp, "r /bin/bash:0x4245c0");
> +	fclose(fp);

Ditto.

> +
> +	/* Ensure the uretprobe is listed in "trace-cmd stat" output. */
> +	ret = grep_match("r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0", "stat", NULL);
> +	CU_TEST(ret == 0);
> +
> +	/* Issue "trace-cmd reset", but keep uretprobes. */
> +	ret = run_trace("reset", "-k", "uretprobe", NULL);
> +	CU_TEST(ret == 0);
> +
> +	/* Verify the uretprobe's existence after reset. */
> +	ret = grep_match("r:uprobes/p_bash_0x4245c0 /bin/bash:0x00000000004245c0", "stat", NULL);
> +	CU_TEST(ret == 0);
> +}
> +
> +static void test_trace_reset_eprobe(void)
> +{
> +	int ret;
> +	bool matched = false;
> +	size_t l = 0;
> +	ssize_t n;
> +	char *buf = NULL;
> +	struct tracefs_dynevent *deprobe;
> +	FILE *fp;
> +
> +	deprobe = tracefs_eprobe_alloc(NULL, "sopen_in", "syscalls", "sys_enter_openat", NULL);
> +	CU_TEST(deprobe != NULL);
> +
> +	ret = tracefs_dynevent_create(deprobe);
> +	CU_TEST(ret == 0);
> +
> +	/* Issue "trace-cmd reset", but keep eprobes. */
> +	ret = run_trace("reset", "-k", "eprobe", NULL);
> +	CU_TEST(ret == 0);
> +
> +	/* Verify the eprobe's existence after reset. */
> +	fp = fopen("/sys/kernel/tracing/dynamic_events", "r");
> +	CU_TEST(fp != NULL);

	int fd;

	fd = tracefs_instance_file_open(NULL, "dynamic_events", O_RDONLY);
	fp = fdopen(fd, "r");

> +
> +	while ((n = getline(&buf, &l, fp)) != -1) {
> +		if (!strcmp(buf, "e:eprobes/sopen_in syscalls.sys_enter_openat\n")) {
> +			matched = true;
> +			break;
> +		}
> +	}
> +	free(buf);

-- Steve

> +
> +	fclose(fp);
> +
> +	CU_TEST(matched == true);
> +
> +	ret = tracefs_dynevent_destroy(deprobe, false);
> +	CU_TEST(ret == 0);
> +
> +	tracefs_dynevent_free(deprobe);
> +}
> +
> +static void test_trace_reset(void)
> +{
> +	int ret;
> +
> +	test_trace_reset_kprobe();
> +	test_trace_reset_kretprobe();
> +	test_trace_reset_uprobe();
> +	test_trace_reset_uretprobe();
> +	test_trace_reset_eprobe();
> +
> +	/* Destroy all dynamic events. */
> +	ret = run_trace("reset", NULL);
> +	CU_TEST(ret == 0);
> +}
> +
>  static int test_suite_destroy(void)
>  {
>  	unlink(TRACECMD_FILE);
> @@ -639,7 +797,7 @@ void test_tracecmd_lib(void)
>  
>  	suite = CU_add_suite(TRACECMD_SUITE, test_suite_init, test_suite_destroy);
>  	if (suite == NULL) {
> -		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACECMD_SUITE);
> +		fprintf(stderr, "Suite \"%s\" cannot be created\n", TRACECMD_SUITE);
>  		return;
>  	}
>  	CU_add_test(suite, "Simple record and report",
> @@ -656,4 +814,5 @@ void test_tracecmd_lib(void)
>  		    test_trace_library_read_back);
>  	CU_add_test(suite, "Test max length",
>  		    test_trace_record_max);
> +	CU_add_test(suite, "Simple reset", test_trace_reset);
>  }

