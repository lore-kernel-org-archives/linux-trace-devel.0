Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66011C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 14:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44021218D3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 14:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfCVOZ1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbfCVOZY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 10:25:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BAD5218D3;
        Fri, 22 Mar 2019 14:25:23 +0000 (UTC)
Date:   Fri, 22 Mar 2019 10:25:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] tools/lib/traceevent: Implement new traceevent
 APIs for accessing struct tep_handler fields
Message-ID: <20190322102521.510691f2@gandalf.local.home>
In-Reply-To: <20190322130742.13753-4-tstoyanov@vmware.com>
References: <20190322130742.13753-1-tstoyanov@vmware.com>
        <20190322130742.13753-4-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Mar 2019 15:07:42 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> As struct tep_handler definition is not exposed as part of libtraceevent API, its fields
> cannot be accessed directly by the library users. This patch implements new APIs, which
> can be used to access the struct tep_handler fields:
> tep_clear_flag(), tep_test_flag(), tep_set_parsing_failures(), tep_get_parsing_failures()
> tep_get_header_page_ts_size(), tep_is_old_format(), tep_set_print_raw() and tep_set_test_filters()

Also, I want to get out of the habit of just listing what changed, and
having a more descriptive change log. It was fine for man pages, but
for adding or modifying the actual code, it needs more detail. Like:

This patch implements new APIs which can be used to access the struct
tep_handle fields:

 tep_get_event() - retrieves an event pointer at a specific index

  modify tep_get_first_event() to use tep_get_event()

 tep_clear_flag() - clears a a tep handle flag

[ BTW, you have in the patch "tep_clear_flags" let's not have it be
  plural. Otherwise we should not be an enum. ]

 tep_test_flag() - test if a given flag is set

 tep_get_header_page_ts_size() - ...

  [ Wait! we are renaming this one. Let's use the new name ]

 tep_get_header_timestamp_size() - returns the size of the timestamp
				   stored in the header.

 tep_get_cpus - returns the number of CPUs

 tep_set_parsing_failures() - internal use function for setting failures

 tep_get_parsing_failures() - Returns what was set above

 tep_is_old_format() - Returns true if data was created by an older
		       kernel with the old data format

 tep_set_print_raw() - Have the output print in the raw format

 tep_set_test_filters() - debugging utility for testing tep filters

-- Steve


> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>

