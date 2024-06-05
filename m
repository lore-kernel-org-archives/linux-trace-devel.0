Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6B618FDBA
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594975; cv=none; b=D5w4qla1nkKdl7uBA7uCbVTkRu2grzU9ylZpAtEWTZCIQ3TMjgeMgC0iGdewTF/muBxWRGKUrrIyPhTET8hgAnV7PdbtwDJDd21a3FGtUkCEJtd3b50zoeTb9nsGX+oYtFvpFtNbCZ4SusFKOfd0bpgdcj5EHCGcwwOpR80Ycho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594975; c=relaxed/simple;
	bh=Xes2ybIkZgsj+NnwJNMkAip/PMVL8bCr9f+jGB7b1hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jt/N1QWwvzW9bVvA01J3p4T/GHAzqPZYZHgN/DFnGGrSzWoX0vgpq9yWIgujdz/eKNs23l9YQSg2dMIxfz8XxG6OFfroNRC5lKgikdWu92kQOsYMPn9BNqJiL1+9ezrIpA8hcuTL6zQbVFvCYKlu2JV7J6XsGtxh6VgAlf/00OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tn2Dl9hB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tn2Dl9hB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iy5yOFXB2vt1uQZoVw3SEYUuTWvHIcOS6gpRrBq2MzI=;
	b=Tn2Dl9hBV1KzbRmDxtTfzyZ4478/SAttFjXDOFDcUonxleHeMTAalAoJ++9o+lab2bFw0S
	9BaG5liVFfMTPO3JdksemqRseFncn0vX4AwPbDPk/YM4LT3C5NkysqtVLj/+5qXi7DDPBh
	uZ2RR9SqJ89zFlf1dSNatfkLLvpjanE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-C-Q0WMOyPiubciJl1jFlJg-1; Wed, 05 Jun 2024 09:42:51 -0400
X-MC-Unique: C-Q0WMOyPiubciJl1jFlJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A844F800076;
	Wed,  5 Jun 2024 13:42:50 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id D7989C15971;
	Wed,  5 Jun 2024 13:42:48 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:48 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 31/38] trace-cmd listen: prevent a infinite loop in communicate_with_client()
Date: Wed,  5 Jun 2024 15:40:46 +0200
Message-ID: <20240605134054.2626953-32-jmarchan@redhat.com>
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

The loop used to read the option is obviously wrong. If the option
isn't read with one call to read(), it will loop indefinitely. Move
the setting of the initial values out of the loop.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-listen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index da46d09e..af9e3454 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -452,9 +452,9 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 				goto out;
 
 			ret = -EIO;
+			t = size;
+			s = 0;
 			do {
-				t = size;
-				s = 0;
 				s = read(fd, option+s, t);
 				if (s <= 0) {
 					free(option);
-- 
2.44.0

