Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B89194AC2
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594909; cv=none; b=Jodq/OqkC7+FhRMUNBNu9FmKYeFuI/v+8CqLqziLG1yssTXC3vRgV85PBOPAgq3csb90OFqJdyKbQjQ12gi3ADVQlnhyqkDOX1ptIvZizC2S8IqAACReaFNxZW21xSzF5/kfs/3ZjrELcYl0aG397/yQk4rHBmZD0xw33I24Nk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594909; c=relaxed/simple;
	bh=2J8GA1bakINdvLCtrk3987PfFz48w6A9trPsMDXxMbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIfrIHtmd2NW3dxPsAouQwUPhkD8Y2j6xbH/7abqkumv3hFzJEp7BH00PsnLRNybzXb2J6ciIqOEAbHGlsKLENnqUv98ZDsFSUzf1A0er+tpcpGLPNhVUqUv9vdyslxMNZYMvtCeTKOUPqgGqnpqTREUvL1YnFxOJBafbWhOdBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iphAEh+B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iphAEh+B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2FDj3oyBf35pPIB1IVZj9/btdZpFvvWMzg2GkAF3AqY=;
	b=iphAEh+Be+srlm06JDVpfo86ORKPvO/OfGzjSoKQ/kQnFs8jtmap8e67ZFOwUpLzAYtWam
	UzrSMd293Me4SEVMzi1Vu2DfVqu3NEvjjEHMG+LN2S1nXjlUYmAOCJNuQfLEEDkIpx20dC
	DmehqhDKwXn7gKDGbiCOa6kJfcPnN7A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-JhFk8FYXNZmWNanT3DCIRA-1; Wed,
 05 Jun 2024 09:41:44 -0400
X-MC-Unique: JhFk8FYXNZmWNanT3DCIRA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E94383806702;
	Wed,  5 Jun 2024 13:41:43 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 1D123C15970;
	Wed,  5 Jun 2024 13:41:41 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:41 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 12/38] trace-cmd hist: close tracecmd handle when trace_hist() exits early
Date: Wed,  5 Jun 2024 15:40:27 +0200
Message-ID: <20240605134054.2626953-13-jmarchan@redhat.com>
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

Call tracecmd_close() before returning if tracecmd_read_headers() fails.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-hist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 62fe4f9b..47dcd6f8 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -1043,8 +1043,10 @@ void trace_hist(int argc, char **argv)
 		die("can't open %s\n", input_file);
 
 	ret = tracecmd_read_headers(handle, 0);
-	if (ret)
+	if (ret) {
+		tracecmd_close(handle);
 		return;
+	}
 
 	ret = tracecmd_init_data(handle);
 	if (ret < 0)
-- 
2.44.0

