Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75400C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Jan 2022 18:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiAYSjv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 13:39:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48402 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiAYSjr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 13:39:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFC22B819FC
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 18:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272CFC340E0;
        Tue, 25 Jan 2022 18:39:45 +0000 (UTC)
Date:   Tue, 25 Jan 2022 13:39:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 00/20] Trace file version 7 - compression
Message-ID: <20220125133934.68e02c27@rorschach.local.home>
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 19 Jan 2022 10:26:55 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Introduced compression of the metadata and trace data in trace files version
> 7. The compression is optional and disabled by default. A new parameter of
> "trace-cmd record" is introduced, which can be used to configure the trace
> file compression:
>  --compression < none / any / name of the desired algorithm >

OK, I finished my review. It's coming along really well.

Thanks Tzvetomir!

-- Steve
