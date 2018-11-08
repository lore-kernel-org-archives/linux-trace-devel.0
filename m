Return-Path: <SRS0=uqUN=NT=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:57472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbeKIEOR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Nov 2018 23:14:17 -0500
Date: Thu, 8 Nov 2018 13:30:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: tep_*host_bigendian()
Message-ID: <20181108133053.6eb22596@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Tzvetomir,

I was looking at the code for tep_is_file_bigendian(),
tep_is_host_bigendian() and tep_host_bigendian().

The tep_host_bigendian() checks if the current machine that is
executing is bigendian or not.

tep_is_host_bigendian() looks at the pevent to see what it has, which
should be the same as tep_host_bigendian().

tep_is_file_bigendian() is if the raw file format is bigendian or not.
If the file does not mach the host, byte swapping needs to be made.

Looking at this deeper, I think the names are backwards.

Let's rename tep_host_bigendian() to tep_is_host_bigendian()
      rename tep_is_host_bigendian() to tep_host_bigendian()
      rename tep_is_file_bigendian() to tep_file_bigendian()


The "is_host" to me sounds more like we are testing the actual host,
where as just saying 'tep_host_bigendian' sounds to me that it's what
the pevent has the host set as.

-- Steve
