Return-Path: <SRS0=1gjG=RE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721CFC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Mar 2019 18:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47B8B20857
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Mar 2019 18:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfCASfW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 13:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbfCASfV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 13:35:21 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D0BA2084F;
        Fri,  1 Mar 2019 18:35:20 +0000 (UTC)
Date:   Fri, 1 Mar 2019 13:35:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: KernelShark info files
Message-ID: <20190301133518.2bfa14f7@gandalf.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Yordan,

When working on the documentation, I noticed that the last session file
is saved in the location that is defined here in CMakeLists.txt:

# Make a directory to hold configuration files. To change this do:
# cmake .. -DKS_CONF_DIR=/your/preferred/path
set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")


It should by default be the environment variable of $HOME/.ksconf.

We should also add an option of --ksconf-path to allow the user to
override it, as well as a KSHARK_CONF_DIR environment variable, such
that we have this:

	if --ksconf-path defined
		ksconf = ksconf-path-arg
	else if ENV(KSHARK_CONF_DIR) definde
		ksconf = ENV(KSHARK_CONF_DIR)
	else
		ksconf = ENV(HOME)/.ksconf

This is basically what other tools do.

-- Steve
