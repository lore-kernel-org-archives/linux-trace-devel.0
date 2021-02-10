Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7892EC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 22:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40C9664E66
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 22:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhBJWDa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 17:03:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231897AbhBJWD3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 17:03:29 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8582A64E08;
        Wed, 10 Feb 2021 22:02:47 +0000 (UTC)
Date:   Wed, 10 Feb 2021 17:02:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest
 tracing session
Message-ID: <20210210170246.727e5773@gandalf.local.home>
In-Reply-To: <CAPpZLN5wdN1V5JTbpdPZQmYx2avnxUJCcZaExGb6-yP1Ly-Ktw@mail.gmail.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
        <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
        <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
        <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
        <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com>
        <CAPpZLN6wUD4wFLLODFL3529vz_khKgvK-PkHspOzA5zEwPeHjQ@mail.gmail.com>
        <acf6979c262a741b7ecb330bb3a1f2e1546385ef.camel@suse.com>
        <CAPpZLN6oQnzgemo2hxqurzOvAdmjvgQkjjx4o1V8Uo3eM_8Ahg@mail.gmail.com>
        <56a35d33639ef7668678fd7f87dab995b2d6a3a7.camel@suse.com>
        <CAPpZLN5wdN1V5JTbpdPZQmYx2avnxUJCcZaExGb6-yP1Ly-Ktw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 9 Feb 2021 19:01:04 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > Ok, is there a WiP already, or someone working on it? I'm asking
> > because maybe I can help.  
> 
> None is working on that yet, any help is highly appreciated :) I just
> created an issue in Bugzilla  for that:
> https://bugzilla.kernel.org/show_bug.cgi?id=211657

I had the below patch locally for some time now. It's a somewhat a hack, but
should work. But this should be done properly. The hack below works if you
include only two files, the host first followed by the guest:

 trace-cmd report -i trace-host.dat -i trace-guest.dat

Also, the following patch should be applied as well:

 https://patchwork.kernel.org/project/linux-trace-devel/patch/20210210164543.5ecd9dbd@gandalf.local.home/

-- Steve

Index: trace-cmd.git/tracecmd/trace-read.c
===================================================================
--- trace-cmd.git.orig/tracecmd/trace-read.c
+++ trace-cmd.git/tracecmd/trace-read.c
@@ -339,6 +339,9 @@ static void add_input(const char *file)
 	last_input_file = item;
 }
 
+static struct tracecmd_input *host;
+static struct tracecmd_input *guest;
+
 static void add_handle(struct tracecmd_input *handle, const char *file)
 {
 	struct handle_list *item;
@@ -358,6 +361,12 @@ static void add_handle(struct tracecmd_i
 			max_file_size = strlen(item->file);
 	}
 	list_add_tail(&item->list, &handle_list);
+	if (handle_list.next != &item->list) {
+		item = container_of(handle_list.next,
+				    struct handle_list, list);
+		host = item->handle;
+		guest = handle;
+	}
 }
 
 static void free_inputs(void)
@@ -1283,6 +1292,8 @@ static void read_data_info(struct list_h
 		}
 	}
 
+	tracecmd_pair_peer(guest, host);
+
 	if (otype != OUTPUT_NORMAL)
 		return;
 
