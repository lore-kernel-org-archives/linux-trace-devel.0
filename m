Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BB6C7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15AAE206BF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfGZHaY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 03:30:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44378 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfGZHaY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 03:30:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hqugI-0006rI-Rr; Fri, 26 Jul 2019 09:30:23 +0200
Message-ID: <a81dd0659b1af4ac4f09b5745556bd45950921ad.camel@sipsolutions.net>
Subject: Re: [PATCH 2/3] trace-cmd: Use PyMemoryView_FromMemory() for Python
 3
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>, Darren Hart <dvhart@infradead.org>,
        troyengel@gmail.com
Date:   Fri, 26 Jul 2019 09:30:22 +0200
In-Reply-To: <20190719225030.345100829@goodmis.org>
References: <20190719224613.207069107@goodmis.org>
         <20190719225030.345100829@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2019-07-19 at 18:46 -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Python 3 has deprecated PyBuffer_FromMemory() and instead has
> PyMemoryView_FromMemory(). Add a helper function that uses the latter if
> Python 3 is detected. As Python 2 is going to be EOL soon, we need to
> support Python 3.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204231

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

