Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BDFC32774
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Aug 2022 17:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiHWRhL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Aug 2022 13:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiHWRgm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Aug 2022 13:36:42 -0400
X-Greylist: delayed 181 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 23 Aug 2022 08:19:00 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BF6DF59
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Aug 2022 08:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1661267751;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=w3zeJm9t5Ppx7ZEIb+hHZ+3isDi7H9YIBxUv4VmdaXg=;
    b=AaCWUyBsVuDt0jOFFtQPn0MUjhUJWe970cu2VH2n4bAKrk6+bSCkmovtEWdMdcHSP/
    UcvIjKcbAOmWC6Gbkqj7M8XUNNqKkU9kL6CRzYVynms07xoPATQqe7VKbWyPZ2Ukpoyr
    GcB7/GAaJNwHdQZWhH6cV0XkS2wyeyTdhb+5/4q9ExbcQIfOlHTxQhCIh0qw9phB54Iy
    EIU/10gemWk8bcXoaXRq7aPBq/iaYLeZfiGoMbgTGytb51nLpVR68HD8tNfJgeu01dhG
    Ippm943GnmBxt5S7RkIYmbbEIEbtGR1B1BAZNgVmKdFp8CqI5lpJxiV+oBQQ3GJ8cGuo
    zeUQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD2QzemV2tdlNlNRZBXiUw="
X-RZG-CLASS-ID: mo00
Received: from linux.micron.com
    by smtp.strato.de (RZmta 47.47.0 AUTH)
    with ESMTPSA id z982dcy7NFFpQxO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 23 Aug 2022 17:15:51 +0200 (CEST)
From:   Bean Huo <beanhuo@iokpp.de>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org,
        tz.stoyanov@gmail.com
Cc:     Bean Huo <beanhuo@micron.com>
Subject: [PATCH] libtraceevent: Documentation: Correct typo in example
Date:   Tue, 23 Aug 2022 17:15:41 +0200
Message-Id: <20220823151541.151549-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

There is no struct tep_event_format, it should be struct tep_event. And
the first parameter in tep_find_event_by_record() should be tep, instead
of pevent.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 Documentation/libtraceevent-field_get_val.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtraceevent-field_get_val.txt b/Documentation/libtraceevent-field_get_val.txt
index 69d51bfc1020..6a5f1cd74f4d 100644
--- a/Documentation/libtraceevent-field_get_val.txt
+++ b/Documentation/libtraceevent-field_get_val.txt
@@ -64,10 +64,10 @@ void process_record(struct tep_record *record)
 {
 	int len;
 	char *comm;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	unsigned long long val;
 
-	event = tep_find_event_by_record(pevent, record);
+	event = tep_find_event_by_record(tep, record);
 	if (event != NULL) {
 		if (tep_get_common_field_val(NULL, event, "common_type",
 					     record, &val, 0) == 0) {
-- 
2.34.1

