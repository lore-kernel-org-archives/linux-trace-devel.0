Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F05C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhKWWDN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 17:03:13 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:29859 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233876AbhKWWDM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 17:03:12 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 23 Nov 2021 14:00:00 -0800
Received: from vypre.local.home (unknown [10.21.245.90])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 1D5BE20146;
        Tue, 23 Nov 2021 14:00:03 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracefs: Update hist example
Date:   Tue, 23 Nov 2021 16:59:55 -0500
Message-ID: <20211123215958.1091307-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Playing with the hist example from the hist man pages, I realized it
should be able to create/show/delet/... user defined events.

Also, updated the sqlhist to take -B as it can create a single
histogram, and that can be done in an instance.

Steven Rostedt (VMware) (3):
  libtracefs/sqlhist: Add -B option to use instances for histograms
  libtracefs/Documentation: Clean up libtracefs-hist man pages
  libtracefs/Documentation: Modify the hist man page example

 Documentation/libtracefs-hist.txt      | 313 +++++++++++++++++++++----
 Documentation/libtracefs-sql.txt       |  28 ++-
 Documentation/libtracefs-sqlhist.txt.1 |   5 +
 3 files changed, 294 insertions(+), 52 deletions(-)

-- 
2.31.1

