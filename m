Return-Path: <SRS0=b+cV=4I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4197C11D04
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Feb 2020 09:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 827B524656
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Feb 2020 09:46:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1fwfBe/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgBTJqi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 04:46:38 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34536 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgBTJqi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 04:46:38 -0500
Received: by mail-lj1-f193.google.com with SMTP id x7so3539322ljc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Feb 2020 01:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uqhm2j+3rv+og+v+YvH1n7/srCKTJWhqzajFus8nyI0=;
        b=F1fwfBe/pKRT+oO6SFrAAkwrADi36cOtbWM2I4oxt88WuR0FK7vVmsaOzTR+NEvE4l
         BaLsp9TG58IrHczkPbUKb66e90WG0zvQPIrR1w9olyo33WMBaQfEaSIpmcfi+FWiNLmS
         o9F/C4lPNSvURwGhIkWvZ58d1nrgyGIFiOeqBeUt7uJn3QNYdId2rFHdF1uPmFLq9x//
         JY2PbCzxlVb301sQu/Ig/ZG1U1Sq+23/0CSwLwfnoDTVCSeDi5Lish4O7l/y90VVBKqp
         e0qzXJAIya/bbhIZRx0bamE3Kyw15loXSiujjT/oPe9/C1sMs9uS4rXrMMvknK/uqBbF
         PuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uqhm2j+3rv+og+v+YvH1n7/srCKTJWhqzajFus8nyI0=;
        b=JniiMds+oPDuLnXlDU9eTjdLueblSA93IYqI1S/poxXgJ193wyTyQgOYj0R5vpwrnT
         7p+GJAqWkh+4G0h1R9bSD5eLlyymG91Zlq1TApAprNV8nLG3YAdDbMKZ46Gr6f6as65Y
         tP1OAH+pLCpX78R+iBSlCy5ggEzPMdN4bfRc8iS4QbbIOGmiZEp2hz6Tqu6THBb5yDcj
         q5Tvjd7yexvkvsusdwjg+3v8ZhoXAdbjtOndfLaudzlUjd2hB2RA37hj2noIXygTQi36
         mtFxKDnXj8MojrXOuO4+COwGEei+aCSndXKZLkBQ0GTTJNYGsrjFwQgOzKExfbt+6Szr
         bzlQ==
X-Gm-Message-State: APjAAAUvaOvijgMRsEWPh0DGdqj0tb3TUx/agkGgyMdbNQ3W9Mh+SU4J
        jUrhv7cM8m1gZlXsWB2f3sQCORoM
X-Google-Smtp-Source: APXvYqyMznH+CxUIJp+Gf4AYhWeBdLHRQ6p8i9jBwuz4DZhmp0/gRx7SRA/DeJvJFsAMtxp4/8x1Zw==
X-Received: by 2002:a2e:b4cf:: with SMTP id r15mr18433453ljm.52.1582191996010;
        Thu, 20 Feb 2020 01:46:36 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l3sm1440201lja.78.2020.02.20.01.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 01:46:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] trace-cmd: Clear synthetic events on reset subcommand
Date:   Thu, 20 Feb 2020 11:46:33 +0200
Message-Id: <20200220094633.468123-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command is supposed to set the ftrace state to default.
However, the synthetic events are not reseted.
A logic is added to delete all entries from "synthetic_events" files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

---
v3: remove the warning in case there are no configured synthetic events
v2: remove the patch from "SQL-like syntax for ftrace histograms configuration" patch set
---
 tracecmd/trace-record.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4a49b640..881efe44 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4638,6 +4638,41 @@ static void clear_triggers(void)
 		clear_instance_triggers(instance);
 }
 
+static void clear_all_synth_events(void)
+{
+	char sevent[BUFSIZ];
+	char *save = NULL;
+	char *line;
+	char *file;
+	char *buf;
+	int len;
+
+	file = tracefs_instance_get_file(NULL, "synthetic_events");
+	if (!file)
+		return;
+
+	buf = read_file(file);
+	if (!buf)
+		goto out;
+
+	sevent[0] = '!';
+
+	for (line = strtok_r(buf, "\n", &save); line; line = strtok_r(NULL, "\n", &save)) {
+		len = strlen(line);
+		if (len > BUFSIZ - 2)
+			len = BUFSIZ - 2;
+		strncpy(sevent + 1, line, len);
+		sevent[len + 1] = '\0';
+		write_file(file, sevent);
+	}
+out:
+	free(buf);
+	tracefs_put_tracing_file(file);
+
+}
+
+
+
 static void clear_func_filters(void)
 {
 	struct buffer_instance *instance;
@@ -5344,6 +5379,7 @@ void trace_reset(int argc, char **argv)
 	set_buffer_size();
 	clear_filters();
 	clear_triggers();
+	clear_all_synth_events();
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
-- 
2.24.1

