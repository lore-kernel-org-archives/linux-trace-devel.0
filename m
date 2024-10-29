Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA75D204011
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 08:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730191638; cv=none; b=MKwkgq9ru2R1ybba1mNp6B/qIWgcXhXemyXnBeY1/DmEHOsfKHMco7Ra4GQNZ/lFyS3NWeV+gLH3qfRXAVLFOEI1pdzBwJfqrAhekGK78Y7SdWqzfBIJlc0c/+RdWQ+jqoPU65bqnwCr1xl45kiI/Y+pbVOmm3eYdTCQNA7NOcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730191638; c=relaxed/simple;
	bh=C4nGzKp0TP5jc9uJUfp2RogGW+aYs5v0NBCirr8we0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BsSHOzNknLKo+J7rq91b61Vnyc1P4l0/Q+QsRHL3eJhSCxAeDK/txJPvKX9hcMd7Szh1CfDQL5bKhXfJIPsH8CS7aBwUzMQdOd6Pm9/gwRWo+SGShPrcO+lq4l07RLDDj51bjbAQfGWCxiRU0VRz0T7jLzJNKhTm5Pj4jD29F88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DNVoURPL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DNVoURPL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730191634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=q3BMHSuIWQyP7H/GIaj0/vioSRALF7t9vfnxRCn/9fc=;
	b=DNVoURPLYLfoAIEW5LTSPZp4SzBAnbP9DD9YIDfxlOF1JoocQPvLbegZqnnSHUzNWS6xru
	rv1ssgEEsDKVzlQ+QgZ5gTGQkI7aTDUN/BkmWSUWuFYPJO1sVjVRNteugTZ50Lzdi8Pxye
	0ztWWei5w7/IirgvCYTyCvlbi17DDTE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-0J3G_nrvNG6f6NOQ-F4KBw-1; Tue,
 29 Oct 2024 04:47:13 -0400
X-MC-Unique: 0J3G_nrvNG6f6NOQ-F4KBw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A35421954221;
	Tue, 29 Oct 2024 08:47:08 +0000 (UTC)
Received: from fedora (unknown [10.45.224.46])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 9AC2E19560A3;
	Tue, 29 Oct 2024 08:47:06 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 29 Oct 2024 09:47:05 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH] trace-cmd: Prevent buffer overflow in update_pid_filters()
Date: Tue, 29 Oct 2024 09:47:05 +0100
Message-ID: <20241029084705.629605-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The buffer in which the updated filter is written in
update_pid_filters() is missing one byte to store the null character.

It fixes the following error:
$ trace-cmd start -e irq:* -e sched:* -P 1
*** buffer overflow detected ***: terminated
Aborted (core dumped)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a008cdfd..8726f9f4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2851,7 +2851,7 @@ static void update_pid_filters(struct buffer_instance *instance)
 	if (fd < 0)
 		die("Failed to access set_event_pid");
 
-	len = instance->len_filter_pids + instance->nr_filter_pids;
+	len = instance->len_filter_pids + instance->nr_filter_pids + 1;
 	filter = malloc(len);
 	if (!filter)
 		die("Failed to allocate pid filter");
-- 
2.47.0

