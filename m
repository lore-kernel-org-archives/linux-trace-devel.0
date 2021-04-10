Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98ABC433B4
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 13:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6994F611CA
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 13:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhDJNyw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 10 Apr 2021 09:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234376AbhDJNyv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Apr 2021 09:54:51 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9678F611AE;
        Sat, 10 Apr 2021 13:54:33 +0000 (UTC)
Date:   Sat, 10 Apr 2021 09:54:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Linux-trace Users <linux-trace-users@vger.kernel.org>
Cc:     Zamir SUN <sztsian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Tony Jones <tonyj@suse.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
Subject: [ANNOUNCE] libtracececmd 1.0.0
Message-ID: <20210410095431.2935816f@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is the initial official release of libtracecmd 1.0.0. This is
needed by KernelShark in order to be in a stand alone repository:

  https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/

All new development for KernelShark now takes place in the above
repository, which will depend on this library. The code that exists
currently in the trace-cmd.git repository for KernelShark will be
removed.

This library lives (and will always live) with the trace-cmd repository.

  https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/trace-cmd-libtracecmd-1.1.0.tar.gz
  https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/

The purpose of his library is to be able to create and read the
trace.dat file that trace-cmd produces. It may also include
functionality to start trace recordings and other features provided by
trace-cmd itself. But for this release, it only contains the bare
necessities that a stand alone KernelShark requires.

The current API for this release are:

 - APIs to open and close a trace.dat file
    tracecmd_open()
    tracecmd_open_head()
    tracecmd_open_fd()
    tracecmd_close()

 - APIs to initialize and read tracing records from a trace.dat file
    tracecmd_init_data()
    tracecmd_read_cpu_first()
    tracecmd_read_data()
    tracecmd_read_at()
    tracecmd_free_record()

 - APIs to retrieve the libtracevent tep handler
    tracecmd_get_tep()

 - APIs to manage host and guest data mappings
    tracecmd_get_traceid()
    tracecmd_get_guest_cpumap()

 - APIs to manage the different instances existing in a trace.dat file
    tracecmd_buffer_instances()
    tracecmd_buffer_instance_name()
    tracecmd_buffer_instance_handle()

Many more APIs will come in later releases.

Enjoy!

-- Steve
