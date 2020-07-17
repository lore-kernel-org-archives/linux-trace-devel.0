Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D03C433E7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3C8B2076D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgGQQMm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 12:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgGQQMj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 12:12:39 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BAAD2070E;
        Fri, 17 Jul 2020 16:12:35 +0000 (UTC)
Date:   Fri, 17 Jul 2020 12:12:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Linux-trace Users <linux-trace-users@vger.kernel.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Changbin Du <changbin.du@gmail.com>,
        Patrick McLean <chutzpah@gentoo.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Clark Williams <williams@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        John Kacur <jkacur@redhat.com>, Tony Jones <tonyj@suse.de>,
        Seth Forshee <seth.forshee@canonical.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Wagner <wagi@monom.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Josef Bacik <jbacik@fb.com>, troyengel@gmail.com,
        Behan Webster <behanw@converseincode.com>
Subject: [ANNOUNCE] trace-cmd 2.9
Message-ID: <20200717121233.5d0d131c@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I'm happy to announce that after over a year, we finally are able to
release trace-cmd version 2.9!


Features and user visible updates since 2.8:

 - git hash is now visible in trace-cmd --version output

 - Build: python-dir can be specified on the command line for python
   location.

 - Build: NO_UDIS86 on make command line to disable udisc86.

 - Build: All headers needed by kernelshark installed.

 - Added --proc-map to trace-cmd record.
   Records the /proc/<pid>/maps of the traced file.
   Used for seeing where page_faults happen (trace-cruncher can use it)

 - Add --user to trace-cmd record, to allow to suid to another user to
   execute the command also on the command line. Useful as trace-cmd needs
   to be run as root to start the tracing, but when root should not be used
   as the application being traced.

 - Build: Install path of plugins have changed:
                   ~/.traceevent/plugins/ --> ~/.local/lib/traceevent/plugins/
   (install_prefix)/lib/trace-cmd/plugins --> (install_prefix)/lib/traceevent/plugins

 - trace-cmd reset will now clear the tracing_cpumask file.

 - ** NEW ** trace-cmd clear
   Clear the trace file.

 - ** NEW ** trace-cmd agent
   Can be run on a guest, which will listen on a vsock for commands.
   trace-cmd report -A Gust <options for guest>
   Will connect to the guest agent and have the agent run tracing commands
   sending the data back to the host. See man pages for more details.
   (note, the synchronization of time stamps is not yet available,
    that will be coming in the next release of trace-cmd).

 - ** NEW ** trace-cmd setup-guest
   Sets up fifos for a guest and host communications instead of vsocks.

 - Add --cmdline_size option to trace-cmd record.
   Changes the number of process names that are saved in the cache while
   tracing.

 - ** NEW ** trace-cmd dump
   Dumps out raw data of the trace.dat file.

 - Build: New: make test
   Builds and runs various unit tests.

 - More information from trace-cmd stat.

 - trace-cmd reset will now clear the error log.

 - Add option '-s' to trace-cmd list.
   This will list the available systems (not events).

 - Recording will now stop if -P is on the command line of trace-cmd record
   and those processes all exit.

 - trace-cmd start can now run commands.
   This is useful when -F and -c are specified on the command line.
   New "--fork" command line to have trace-cmd not wait for the command to
   finish before exiting.

 - ** New ** trace-cmd set command.
   Used to set or unset options without messing with other ftrace options.

Plus many fixes and infrastructure improvements.
Changes are also made to set up having libtraceevent, libtracefs and
kernelshark be moved into their own git repositories.

We plan on working more more aggressively on the libraries and the tool
set, such that 3.0 wont take a year to be released.

For more information please visit: https://trace-cmd.org

If you would like to contribute, check out the above web site for where
we do our development, and feel free to contact us on how to get
involved.

Enjoy,

-- Steve
