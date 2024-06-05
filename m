Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2741957FB
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594968; cv=none; b=oRFPDojwqNcL7qqSXvSYQg/4614g2fIamsceFjSNEFAme9J3FGCqgL767ILqGAK5Yvy62d3Z2dXfNG/F2OT4zB8/792/QEZCEt6qTAjA6wpERj8VTb79nOwvjB1MD+G7KiXuKAmLT0arDmMGjHekQe9xo+A8ZrL/6R4YewHKqTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594968; c=relaxed/simple;
	bh=IpJEsPfL6voeh40QFqUj2D2un4yosns91vcjCNhEpBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d33KqMyloS0PKHNCzsOs3srF8JyTHC/P19wiY6a4BpSNKbg54B2DxQrQu0fdDiJm5IMTUfpt6T2IMxv4vPjVQt11ZxqRTAzHyzgy76Oyjl0NLQVQKFwW5V4acl6z91ctq+TidjcpelyDduG52V8ikeIDI3cn/7r3vlKgTdlqptE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvsWO201; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvsWO201"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IhONIFqBSJgjIozMPT1SV7swMmlk5UlMBJUPr+Lpo2g=;
	b=dvsWO201+6Tw//IRdJk4BNCQ+tQEIM4OxE7GEMRHAqNhOPPmsQ3BrTRtOChYTCcg6Kphtf
	dK7gAB/cVm7Uczd/XbRt/LL5UXN/k9CNxWp4FLkLyu1l8JfsteCGrySx4FgPKrgCnIo5po
	2GB4iiDW+5KP8kIqDog2TScnPUffVj4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-chB8zVvvOriXjaLVW4H1pw-1; Wed,
 05 Jun 2024 09:42:45 -0400
X-MC-Unique: chB8zVvvOriXjaLVW4H1pw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F11943806700;
	Wed,  5 Jun 2024 13:42:44 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 24EE51C0005E;
	Wed,  5 Jun 2024 13:42:42 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:42 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 29/38] trace-cmd record: prevent memory leak in setup_network()
Date: Wed,  5 Jun 2024 15:40:44 +0200
Message-ID: <20240605134054.2626953-30-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Because of the again label, msg_handle can be already allocated if we
exit after we got a negative socket file descriptor. Free it there.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b4cbd438..770e775b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3903,6 +3903,7 @@ static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instanc
 
 	if (sfd < 0) {
 		free(thost);
+		free(msg_handle);
 		return NULL;
 	}
 
-- 
2.44.0

