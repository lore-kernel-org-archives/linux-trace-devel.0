Return-Path: <SRS0=5FGG=3E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549E9C32771
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jan 2020 19:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E39222C3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jan 2020 19:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgAOTbL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 14:31:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAOTbK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 14:31:10 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0AD12081E;
        Wed, 15 Jan 2020 19:31:09 +0000 (UTC)
Date:   Wed, 15 Jan 2020 14:31:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Koepi <john.koepi@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf] traceevent: ignore __attribute__ in fields format
Message-ID: <20200115143108.026cc2c1@gandalf.local.home>
In-Reply-To: <CAJ8z9b0fHwOUgF_AgXED3wuZpOVbQTfGA3WkNbNFCmiY_Br3Tw@mail.gmail.com>
References: <CAJ8z9b1RD4gyPg8_B2sW=ULEjLRLTZrCAWc=k2=d8wSrhMBbOQ@mail.gmail.com>
        <20200115180645.53331-1-john.koepi@gmail.com>
        <CAJ8z9b0fHwOUgF_AgXED3wuZpOVbQTfGA3WkNbNFCmiY_Br3Tw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 15 Jan 2020 20:47:47 +0200
John Koepi <john.koepi@gmail.com> wrote:

> I am not sure this is the right mailing list (I was not sure about
> @netdev). If it is not - I am sorry, I can resend it. The test for
> this change is at https://github.com/sitano/traceevent_attribute.
> 

It's fine to send it here. It's in my queue to look at.

Thanks!

-- Steve

