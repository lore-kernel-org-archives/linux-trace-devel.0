Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00194383
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594927; cv=none; b=Mz3jOIMwlZ0RBHpZ6iD7AjF79CVnWWMq8nDwHTiyRGrUtxawW6d2pRjccK9nUgPrFBz8IzxOK56wDUbAHSg8RWJ67hBG83iXlbxPEPp5BzK4lPzjSBL/pNfdf1J3ELUgXH9F9blIVpIlcEW+nNDplNCZeR9/TWRZWIb696oR6Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594927; c=relaxed/simple;
	bh=9bQlDZW+VFD+rnIm39+7Y1t9V1YX/9f1B/TPwk9urP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rv0QJFWs9O898YvIJGjwkkFwEX/dd+2Ab6/PznVy+cz4aF30G8WGs4qxEueMj+cCjM+plE/zVfGx5K26p08tCW7ThqXuHQIYjHQTtWjQupquq8uYydQQhul7yVAa18HOM3++e/A8dGtwQtBeVlRWes6Hswi2eGecG+KZ9j3/Oio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gh3CE0QF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gh3CE0QF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S6nRBfSy5fQHzGiA/diBKUgulvdouKq4yo3YET0FB6k=;
	b=Gh3CE0QFdYSU/vtNaOaBLm6Bl/p5FL2jrX3SQMmN3/9+E94stywWSMQko599/xoCx5/PSd
	B4tBpqlQ5p7+5T4eebqheSMwjzOPG0mo0qJzj8mkZuzF4eC6KwxAPEzm+mrkfUTCd5FP9k
	+X+ofibFJeKiomV/nFYnkCMdQxg6Tq4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-3vRnG5lXMRmxIc5xhUjdEw-1; Wed,
 05 Jun 2024 09:42:02 -0400
X-MC-Unique: 3vRnG5lXMRmxIc5xhUjdEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D14EE1C0512D;
	Wed,  5 Jun 2024 13:42:00 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 03CC0C15970;
	Wed,  5 Jun 2024 13:41:58 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:58 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 17/38] trace-cmd lib: prevent memory leak in ptp_clock_server()
Date: Wed,  5 Jun 2024 15:40:32 +0200
Message-ID: <20240605134054.2626953-18-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

The pointer results is allocated in tracecmd_msg_recv_time_sync(). It
isn't freed if ptp_clock_server() exits with an error. Free it in the
error path.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-timesync-ptp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
index 20e6e6f1..402edeb2 100644
--- a/lib/trace-cmd/trace-timesync-ptp.c
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -608,8 +608,10 @@ static int ptp_clock_server(struct tracecmd_time_sync *tsync,
 					  sync_proto, &sync_msg,
 					  &size, (char **)&results);
 	if (ret || strncmp(sync_proto, PTP_NAME, TRACECMD_TSYNC_PNAME_LENGTH) ||
-	    sync_msg != PTP_SYNC_PKT_PROBES || size == 0 || results == NULL)
+	    sync_msg != PTP_SYNC_PKT_PROBES || size == 0 || results == NULL) {
+		free(results);
 		return -1;
+	}
 
 	ntoh_ptp_results(results);
 	if (ptp->flags & PTP_FLAG_USE_MARKER)
-- 
2.44.0

