Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBDF81F
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594949; cv=none; b=EGSFL9bbmRWWCKCxe9Y60DXm1GMF6CmjF/orF2e7JUklLtQ9m27AjIK1qbVgSfEO2E+2otI7Ib4BX294EJ+j4TNicP0siQB+YnJnBCuqTCH4IY+egavnoNYP85GqOikAe0t7xwsTNPZWaGqk/dybR3EXWF4F9+0l3xknVqV8fkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594949; c=relaxed/simple;
	bh=V9g3zGsdvEeYMLvTodkdwPMwpH067mkz3hStftE/7D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDbDbC+Km73B39EVxqujjxPJ/dnAtZQGD4UUfK7PEq5MQcmN3DIqnRyTZw3aVYs9PpXxSEyTdFaXiZAcQXGNPCQI644GoXu+xqXR0DExWFirsC8OODFAGPk/km0mN5o9X/iOxPXVWI2f7Dlnx8mkRXBRxLprs6P7QQETskk32RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V+AHS99k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V+AHS99k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aHV3qq2prNNSL+K6lDj1Fo9TduGupxQ4gKUt5bnUCn0=;
	b=V+AHS99kynVSnzRaIIGTj7E11xyHOK67NHp7bqKjnPsjz6xLuGKPSBafom4D9FR8L31YnG
	jELiDcTGUqI2XW6lgV3GaEAB5dcB2QEqCDRIim2iKd6d/hXt28H8JCvyry5MJkSBXr7RBI
	E/Q9F7581XvLfJMOVKCwfYZzZgob/FY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-JnYEYtehPp-o1U-p11PiNA-1; Wed,
 05 Jun 2024 09:42:20 -0400
X-MC-Unique: JnYEYtehPp-o1U-p11PiNA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82B2029AA386;
	Wed,  5 Jun 2024 13:42:20 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id 3B2C7492BE8;
	Wed,  5 Jun 2024 13:42:17 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:16 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 22/38] trace-cmd dump: prevent buffer overrun in dump_clock()
Date: Wed,  5 Jun 2024 15:40:37 +0200
Message-ID: <20240605134054.2626953-23-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

The clock isn't big enough to hold the string with the null
terminating character. Worse, clock[size], which is out of range, is
set to 0. Allocate a big enough buffer.

Fixes an OVERRUN error (CWE-119)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 11c1baf1..c0a282c9 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -961,7 +961,7 @@ static void dump_clock(int fd)
 	}
 	if (read_file_number(fd, &size, 8))
 		die("cannot read clock size");
-	clock = calloc(1, size);
+	clock = calloc(1, size+1);
 	if (!clock)
 		die("cannot allocate clock %lld bytes", size);
 
-- 
2.44.0

