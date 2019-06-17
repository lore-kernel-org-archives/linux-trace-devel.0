Return-Path: <SRS0=wRMB=UQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D495C31E50
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 14:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A34F2084B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 14:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfFQOMN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 10:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFQOMN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 10:12:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33DFE2084B;
        Mon, 17 Jun 2019 14:12:12 +0000 (UTC)
Date:   Mon, 17 Jun 2019 10:12:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     tz.stoyanov@gmail.com
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Save the tracee memory map into the
 trace.dat file.
Message-ID: <20190617101210.6bbf05ac@gandalf.local.home>
In-Reply-To: <20190617093722.71de482b@gandalf.local.home>
References: <20190617115218.6279-1-tz.stoyanov@gmail.com>
        <20190617115218.6279-3-tz.stoyanov@gmail.com>
        <20190617093722.71de482b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 17 Jun 2019 09:37:22 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> As stated in the last email. The vector size is hard coded as 2, which
> is why I'm reluctant to add a vector version now. If it was dynamic,
> then that would be more of a reason. Here we can just create our own
> structure and use that:
> 
> 	struct tracecmd_map_file {
> 		int		nr_maps;
> 		int		maps_len;
> 		char		*maps;
> 	}
> 
> Or something like that.

As you can't send that to the tracecmd_add_option, you would need
something more like this:

	struct tracecmd_map_file {
		int		nr_maps;
		int		maps_len;
		char		maps[0];
	};

And then you would need to copy it first before sending it:


	struct tracecmd_map_file *tmap;

	tmap = malloc(sizeof(*tmap) + s.len + 1);
	
	and copy the buffer:

	memcpy(&tmap->maps[0], s.buffer, s.len + 1);

before sending it to tracecmd_add_option();

-- Steve
