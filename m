Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE43D188CB6
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594991; cv=none; b=YIbom+ynlUq5ALShryoPjWJG+2fAcmiG2rJzNcIIAkJ7+XjbNgqVUNVEJgyRJFpiYfGDrj5wdYdG5LD4+PfmMD0xatJks2z5FMW5tUmObgaqKq0K73eBptur/FNFGO85k7hjl/qCYi4kMIzPY2kDAIXh8JeecG/E4rt+xz642y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594991; c=relaxed/simple;
	bh=N8dbMdqcDgov9/BcKzO62yaI50kLOOyCgucWaNmZgsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1u81cgGpwP7IcxZDZj4vczn7bxhqx2Fa4lqBHAwndu+jw0GnAy3zKeLDFrYtRL+t9XbDQ48GS0pIqVoja6a3VGKMPEzaskAH5MoNcC4DI1OmC3oY1IYJIVC+FEkh5zLNiGmhDnnKFHqQRL4H3SYA72YfuFMv2nb4aC2oNSby0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gveHiy6n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gveHiy6n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XivCqcxxbi9XGMRzeca5GIKT3G1BGoqqUwYOM3H//eM=;
	b=gveHiy6nLh6yeJ+FmauudWakUy7slgxoi+7Qn9+9sNkhEUOlzWumRbh+WjzGpLYkD4a1DB
	aazcHi3Zz3I6Vzm+CE+B3Tq8MoyvUZLodl6Fgzr2kW6TRQlAOh3rjICCGNS1q1fkiZchs8
	Uqusrsh5Y6KPL2MWwUAZm7JWEdafkBw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-nH-WPatIMfWuKYv9YA6iSw-1; Wed,
 05 Jun 2024 09:43:07 -0400
X-MC-Unique: nH-WPatIMfWuKYv9YA6iSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64D9F3C025B2;
	Wed,  5 Jun 2024 13:43:07 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 441D437D0;
	Wed,  5 Jun 2024 13:43:05 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:43:04 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 36/38] trace-cmd record: check the length of the protocol version received
Date: Wed,  5 Jun 2024 15:40:51 +0200
Message-ID: <20240605134054.2626953-37-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

In check_protocol_version we compare the protocol version string with
the expected one ("V3") with memcmp(). The received string could be
longer than the constant string used for the comparison. That could
lead to out of range access.

Check that the received protocol version is not too long.

Fixes a OVERRUN error (CWE-119)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index dc3e5285..c3118546 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3810,7 +3810,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 		msg_handle->version = V1_PROTOCOL;
 		tracecmd_plog("Use the v1 protocol\n");
 	} else {
-		if (memcmp(buf, "V3", n) != 0)
+		if (n > 3 || memcmp(buf, "V3", n) != 0)
 			die("Cannot handle the protocol %s", buf);
 		/* OK, let's use v3 protocol */
 		write(fd, V3_MAGIC, sizeof(V3_MAGIC));
-- 
2.44.0

