Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87085C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 14:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5665A218FC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 14:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfCVOJJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbfCVOJI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 10:09:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE4C5218E2;
        Fri, 22 Mar 2019 14:09:07 +0000 (UTC)
Date:   Fri, 22 Mar 2019 10:09:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/perf,tools/lib/traceevent: Make traceevent APIs
 more consistent
Message-ID: <20190322100905.7d62691b@gandalf.local.home>
In-Reply-To: <20190322130816.13903-1-tstoyanov@vmware.com>
References: <20190322130816.13903-1-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Mar 2019 15:08:16 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Rename few traceevent APIs, in order to make it more consistent:
> tep_pid_is_registered(), tep_file_bigendian(),
> tep_is_latency_format(), tep_get_header_page_ts_size(),
> tep_set_host_bigendian(), tep_is_host_bigendian() and
> tep_data_lat_fmt()

Note, change logs should be about "why" not "what". The above is mostly
about "what" although you did state "to make it more consistent" which
is a "why", but we should elaborate more. Something like this:

=====================================
Rename some traceevent APIs for consistency:

 tep_pid_is_registered() to tep_is_pid_registered()

as the convention is "tep_is" not "tep_X_is".

 tep_file_bigendian() to tep_is_file_bigendian()

as boolean operations will now have "tep_is_" notation

 tep_get_header_page_ts_size() to tep_get_header_timestamp_size()

as the latter is more descriptive.

 tep_set_host_bigendian() to tep_set_local_bigendian()
 tep_is_host_bigendian() to tep_is_local_bigendian()

because "host" can be confused with VMs, and "local" is about the local
machine.

 tep_host_bigendian() to tep_is_bigendian()

Again "host" is confusing and we are converting to "tep_is_" notation,
also this one checks the actual machine that is running. For
consistency we have:

  bool tep_is_bigendian(void);
  bool tep_is_file_bigendian(struct tep_handle *tep);
  bool tep_is_local_bigendian(struct tep_handle *tep);

Where tep_is_X_bigendian(tep) returns the saved data in the tep handle,
and tep_is_bigendian() returns the running machine's endianess.

 tep_data_lat_fmt() to tep_data_latency_format()

No need to obfuscate with shorten names here.

Switching all "tep_is_" functions to return bool and not int.
=====================================

That is much more descriptive of the change, and lets anyone that looks
at the git history see exactly why things have changed. With a more
descriptive change log, it will cause less arguments as well.

Please resend with an updated change log.

-- Steve

