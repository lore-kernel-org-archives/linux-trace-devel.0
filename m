Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7184195FE5
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594867; cv=none; b=FC5LAQF9edudGb6Aor6CWMZNDZBcpuVl8xRoOe3mpIWNC/IWrSryquYATm0lncI64354Q6DJt3lDGAeNkTnh94sUqU//K6Mlw+FG1IQ2SCThc4Zy6L0TK7o72AeVRUzDau90iBtkMeN4oMXYO/GYFmt+XlzNue9Ukshu+q7X9DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594867; c=relaxed/simple;
	bh=Gyf0Ao0Z2gjWvuNmJS3dHbHkhe1u6OjzaStYIP3Y74Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUrVJNk4upRRqlL71IKs0/4T4DCmhAmtSQGOcuk+vqTmAV8RPJEx/X0JsL4Eqg55nzU2mYZi19XM+T0MeD9Is+SAWbyuXQVsa23KY7FA4a5ahyjsFPKauavO8R5CiKYtwmMrMux5CGswkeq8AJksZUkez32XMoPpZxQ9k5GvtFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ixqa5WRf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ixqa5WRf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2VqFyjphm+3LAKVuySnRLNB5SrdYb9PbNw/VjFFGRr4=;
	b=ixqa5WRfbLWPX0P5Le6nkPFPc4rcCO+KomI1k21CpME2FKvHIjUXqh2HmRLCebWP9jLajE
	GY2FdC8Jd/PJrUZtVEDev6Qqd2pqehRJXj54+LpyLDV4npRKnkJBUstIouOrNzfK73do+J
	3adfTVO7YZ8H3b2yzqJBz1XECtsPurw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-bdU2IUz0Pjiq09hBfWw5Fg-1; Wed, 05 Jun 2024 09:41:01 -0400
X-MC-Unique: bdU2IUz0Pjiq09hBfWw5Fg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F8C085A588;
	Wed,  5 Jun 2024 13:41:01 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 68C6737D0;
	Wed,  5 Jun 2024 13:40:59 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:40:58 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 01/38] trace-cmd listen: close ofd before exiting process_client()
Date: Wed,  5 Jun 2024 15:40:16 +0200
Message-ID: <20240605134054.2626953-2-jmarchan@redhat.com>
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

Close ofd in the error path and at the end of the function.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-listen.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 5894a92d..09f442c7 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -696,8 +696,10 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	ofd = create_client_file(node, port);
 
 	pid_array = create_all_readers(node, port, pagesize, msg_handle);
-	if (!pid_array)
+	if (!pid_array) {
+		close(ofd);
 		return -ENOMEM;
+	}
 
 	/* on signal stop this msg */
 	stop_msg_handle = msg_handle;
@@ -725,6 +727,7 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 					msg_handle->version < V3_PROTOCOL);
 
 	destroy_all_readers(cpus, pid_array, node, port);
+	close(ofd);
 
 	return ret;
 }
-- 
2.44.0

